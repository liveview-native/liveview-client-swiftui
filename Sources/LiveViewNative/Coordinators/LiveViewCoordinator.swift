//
//  LiveViewCoordinator.swift
//  
//
//  Created by Carson Katri on 1/6/23.
//

import Foundation
import SwiftPhoenixClient
import SwiftSoup
import Combine
import LiveViewNativeCore
import OSLog

private var PUSH_TIMEOUT: Double = 30000

private let logger = Logger(subsystem: "LiveViewNative", category: "LiveViewCoordinator")

@MainActor
public class LiveViewCoordinator<R: CustomRegistry>: ObservableObject {
    @Published internal private(set) var internalState: LiveSessionCoordinator<R>.InternalState = .notConnected(reconnectAutomatically: false)
    
    var state: LiveSessionCoordinator<R>.State {
        internalState.publicState
    }
    
    let session: LiveSessionCoordinator<R>
    let url: URL
    
    private var channel: Channel?
    
    @Published var document: LiveViewNativeCore.Document?
    let elementChanged = PassthroughSubject<NodeRef, Never>()
    private var rendered: Root!
    internal let builder = ViewTreeBuilder<R>()
    
    private var currentConnectionToken: ConnectionAttemptToken?
    private var currentConnectionTask: Task<Void, Error>?
    
    private var eventHandlers: [String: (Payload) -> Void] = [:]
    
    let liveRedirect = PassthroughSubject<LiveRedirect, Never>()
    
    init(session: LiveSessionCoordinator<R>, url: URL) {
        self.session = session
        self.url = url
    }
    
    /// Pushes a LiveView event with the given name and payload to the server.
    ///
    /// This is an asynchronous function that completes when the server finishes processing the event and returns a response.
    /// The client view tree will be updated automatically when the response is received.
    ///
    /// - Parameter type: The type of event that is being sent (e.g., `click` or `form`). Note: this is not currently used by the LiveView backend.
    /// - Parameter event: The name of the LiveView event handler that the event is being dispatched to.
    /// - Parameter value: The event value to provide to the backend event handler. The value _must_ be  serializable using ``JSONSerialization``.
    /// - Throws: `FetchError.eventError` if an error is encountered sending the event or processing it on the backend, `CancellationError` if the coordinator navigates to a different page while the event is being handled
    public func pushEvent(type: String, event: String, value: Any) async throws {
        // isValidJSONObject only accepts objects, but we want to check that the value can be serialized as a field of an object
        precondition(JSONSerialization.isValidJSONObject(["a": value]))
        try await doPushEvent("event", payload: [
            "type": type,
            "event": event,
            "value": value,
        ])
    }
    
    internal func doPushEvent(_ event: String, payload: Payload) async throws {
        guard let channel = channel else {
            return
        }
        
        let token = self.currentConnectionToken

        let replyPayload = try await withCheckedThrowingContinuation({ continuation in
            channel.push(event, payload: payload, timeout: PUSH_TIMEOUT)
                .receive("ok") { reply in
                    continuation.resume(returning: reply.payload)
                }
                .receive("error") { message in
                    continuation.resume(throwing: LiveConnectionError.eventError(message))
                }
        })
        
        guard currentConnectionToken === token else {
            // TODO: maybe this should just silently fail?
            throw CancellationError()
        }
        
        if let diffPayload = replyPayload["diff"] as? Payload {
            do {
                try self.handleDiff(payload: diffPayload, baseURL: self.url)
            } catch {
                fatalError("todo")
            }
        } else if session.config.liveRedirectsEnabled,
                  let redirect = (replyPayload["live_redirect"] as? Payload).flatMap({ LiveRedirect(from: $0, relativeTo: self.url) }) {
            liveRedirect.send(redirect)
        }
    }
    
    private func handleDiff(payload: Payload, baseURL: URL) throws {
        if session.config.eventHandlersEnabled,
           let events = payload["e"] as? [[Any]] {
            for event in events {
                guard let name = event[0] as? String,
                      let value = event[1] as? Payload,
                      let handler = eventHandlers[name] else {
                    continue
                }
                handler(value)
            }
        }
        let diff = try RootDiff(from: FragmentDecoder(data: payload))
        self.rendered = try self.rendered.merge(with: diff)
        self.document?.merge(with: try Document.parse(self.rendered.buildString()))
    }
    
    private nonisolated func parseDOM(html: String, baseURL: URL) throws -> Elements {
        // we parse the DOM as XML rather than HTML, because we don't want it to apply browser-specific HTML transformations
        // such as <image> -> <img>
        let document = try Parser.xmlParser().parseInput(html, baseURL.absoluteString)
        return document.children()
    }
    
    func connect() async {
        if let channel {
            guard !channel.isJoined, !channel.isJoining else { return }
        }
        do {
            try await connectLiveView()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // todo: don't use Any for the params
    private func connectLiveView() async throws {
        guard let socket = session.socket else { return }
        
        var connectParams = session.config.connectParams?(self.url) ?? [:]
        connectParams["_mounts"] = 0
        connectParams["_csrf_token"] = session.phxCSRFToken
        connectParams["_platform"] = "ios"
        
        let params: Payload = [
            "session": session.phxSession,
            "static": session.phxStatic,
            "url": self.url.absoluteString,
            "params": connectParams,
        ]
        
        let channel = socket.channel("lv:\(self.session.phxID)", params: params)
        self.channel = channel
        channel.onError { message in
            logger.error("[Channel] Error: \(String(describing: message))")
        }
        channel.onClose { message in
            logger.info("[Channel] Closed")
        }
        channel.on("diff") { message in
            Task { @MainActor in
                try! self.handleDiff(payload: message.payload, baseURL: self.url)
            }
        }
        channel.on("phx_close") { message in
            DispatchQueue.main.async {
                self.internalState = .notConnected(reconnectAutomatically: false)
            }
        }
        
        let renderedPayload: Payload = try await withCheckedThrowingContinuation { continuation in
            self.internalState = .awaitingJoinResponse(continuation)
            setupChannelJoinHandlers(channel: channel)
        }
        
        Task { @MainActor in
            handleJoinPayload(renderedPayload: renderedPayload)
        }
    }
    
    private func setupChannelJoinHandlers(channel: Channel) {
        channel.join()
            .receive("ok") { [weak self] message in
                guard let self = self else {
                    // leave the channel so we don't get any more messages/automatic rejoins
                    channel.leave()
                    if case .awaitingJoinResponse(let continuation) = self?.internalState {
                        continuation.resume(throwing: CancellationError())
                    }
                    return
                }
                let renderedPayload = (message.payload["rendered"] as! Payload)
                if case .awaitingJoinResponse(let continuation) = self.internalState {
                    // if we're in the state of attempting to establish the initial connection, resume the async task
                    continuation.resume(returning: renderedPayload)
                } else if self.internalState.reconnectAutomatically {
                    // if we're in a state where, e.g., a previous attempt failed, but an automatic rejoin attempt succeeds, finish the join
                    Task { @MainActor in
                        self.handleJoinPayload(renderedPayload: renderedPayload)
                    }
                } else {
                    // if we've received a message but don't have anything to do with it,
                    // assume that that will continue to be the case, and leave the channel to prevent future messages
                    channel.leave()
                }
            }
            .receive("error") { [weak self] message in
                // TODO: reconsider this behavior, web tries to automatically rejoin, and we do to when an error is encountered after a successful join
                // leave the channel, otherwise the it'll continue retrying indefinitely
                // we want to control the retry behavior ourselves, so just leave the channel
                channel.leave()
                
                guard let self = self else {
                    if case .awaitingJoinResponse(let continuation) = self?.internalState {
                        continuation.resume(throwing: CancellationError())
                    }
                    return
                }
                
                if self.session.config.liveRedirectsEnabled,
                   let redirect = (message.payload["live_redirect"] as? Payload).flatMap({ LiveRedirect(from: $0, relativeTo: self.url) }) {
                    self.liveRedirect.send(redirect)
                } else {
                    if case .awaitingJoinResponse(let continuation) = self.internalState {
                        continuation.resume(throwing: LiveConnectionError.joinError(message))
                    } else if self.internalState.reconnectAutomatically {
                        // TODO: reconnectAutomatically is a bit of a misnomer here,
                        Task { @MainActor in
                            self.internalState = .connectionFailed(LiveConnectionError.joinError(message))
                        }
                    }
                }
            }
    }
    
    private func handleJoinPayload(renderedPayload: Payload) {
        // todo: what should happen if decoding or parsing fails?
        self.rendered = try! Root(from: FragmentDecoder(data: renderedPayload))
        self.internalState = .connected
        self.document = try! LiveViewNativeCore.Document.parse(rendered.buildString())
        self.document?.on(.changed) { [unowned self] doc, nodeRef in
            // text nodes don't have their own views, changes to them need to be handled by the parent Text view
            if case .leaf(_) = doc[nodeRef].data,
               let parent = doc.getParent(nodeRef) {
                self.elementChanged.send(parent)
            } else {
                self.elementChanged.send(nodeRef)
            }
        }
    }
}

extension LiveViewCoordinator {
    /// This token represents an individual attempt at connecting to a particular Live View.
    ///
    /// If a new navigation/connection attempt interrupts an in-progress one, the token allows
    /// dangling completion handlers to detect that they've been preempted and cancel themselves.
    ///
    /// The URL cannot be used for this purpose, because the previous and new URLs may be the same
    /// (e.g., due to live reload).
    ///
    /// This class deliberately does not implement `Equatable` and reference equality (`===`) is used to
    /// check token validatity. A token is constructed at the beginning of a connection attempt, set as the coordinator's
    /// current token, and compared to the then-current one in asynchronous callbacks.
    class ConnectionAttemptToken {}
}
