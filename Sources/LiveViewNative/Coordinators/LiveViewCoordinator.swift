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

/// The live view coordinator manages the connection to a particular LiveView on the backend.
///
/// ## Topics
/// ### LiveView Events
/// - ``pushEvent(type:event:value:)``
/// - ``receiveEvent(_:)``
/// - ``handleEvent(_:handler:)``
@MainActor
public class LiveViewCoordinator<R: CustomRegistry>: ObservableObject {
    @Published internal private(set) var internalState: LiveSessionCoordinator<R>.InternalState = .notConnected(reconnectAutomatically: false)
    
    var state: LiveSessionCoordinator<R>.State {
        internalState.publicState
    }
    
    let session: LiveSessionCoordinator<R>
    var url: URL
    
    private var channel: Channel?
    
    @Published var document: LiveViewNativeCore.Document?
    let elementChanged = PassthroughSubject<NodeRef, Never>()
    private var rendered: Root!
    internal let builder = ViewTreeBuilder<R>()
    
    private var currentConnectionToken: ConnectionAttemptToken?
    private var currentConnectionTask: Task<Void, Error>?
    
    private var eventSubject = PassthroughSubject<(String, Payload), Never>()
    private var eventHandlers = Set<AnyCancellable>()
    
    init(session: LiveSessionCoordinator<R>, url: URL) {
        self.session = session
        self.url = url
        
        self.handleEvent("native_redirect") { [weak self] payload in
            guard let self,
                  let redirect = LiveRedirect(from: payload, relativeTo: self.url)
            else { return }
            Task {
                await session.redirect(redirect)
            }
        }
    }
    
    /// Pushes a LiveView event with the given name and payload to the server.
    ///
    /// This is an asynchronous function that completes when the server finishes processing the event and returns a response.
    /// The client view tree will be updated automatically when the response is received.
    ///
    /// - Parameter type: The type of event that is being sent (e.g., `click` or `form`). Note: this is not currently used by the LiveView backend.
    /// - Parameter event: The name of the LiveView event handler that the event is being dispatched to.
    /// - Parameter value: The event value to provide to the backend event handler. The value _must_ be  serializable using ``JSONSerialization``.
    /// - Throws: ``LiveConnectionError/eventError(_:)`` if an error is encountered sending the event or processing it on the backend, `CancellationError` if the coordinator navigates to a different page while the event is being handled
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
            await session.redirect(redirect)
        }
    }
    
    /// Creates a publisher that can be used to listen for server-sent LiveView events.
    ///
    /// - Parameter event: The event name that is being listened for.
    /// - Returns: A publisher that emits event payloads.
    ///
    /// To handle events, use the `sink` subscriber:
    /// ```swift
    /// myEventHandler = coordinator.receiveEvent("my_event")
    ///     .sink { payload in
    ///         print("Received payload: \(payload)")
    ///     }
    /// ```
    /// The `sink` method returns an `AnyCancellable` which can be used to later stop listening for events by calling its `cancel` method.
    ///
    /// - Important: `AnyCancellable` will cancel itself upon deinitialization, so you must hold a strong reference to it for the duration you want to keep receiving events. If you want to keep listenting for the lifetime of the coordinator, you may use ``handleEvent(_:handler:)``.
    ///
    /// This publisher is _not_ guaranteed to fire on the main thread.
    /// If you need to perform UI updates, use the `receive(on:)` operator, as shown below.
    /// ```swift
    /// coordinator.receiveEvent("my_event")
    ///     .receive(on: DispatchQueue.main)
    ///     .sink { payload in
    ///         myUIObject.value = payload["value"] as! String
    ///     }
    ///     .store(in: &cancellables)
    /// ```
    ///
    /// If you are using SwiftUI's `onReceive` modifier, applying `receive(on:)` to the publisher is not necessary.
    /// ```swift
    /// struct MyView: View {
    ///     let context: LiveContext<EmptyRegistry>
    ///     @State private var text = "Hello"
    ///     var body: some View {
    ///         Text(text)
    ///             .onReceive(context.coordinator.receiveEvent("my_event")) { payload in
    ///                 self.text = payload["text"] as! String
    ///             }
    ///     }
    /// }
    /// ```
    public func receiveEvent(_ event: String) -> some Publisher<Payload, Never> {
        eventSubject
            .filter { $0.0 == event }
            .map(\.1)
    }
    
    /// Permanently registers a handler for a server-sent LiveView event.
    ///
    /// - Parameter event: The event name that is being listened for.
    /// - Parameter handler: A closure to invoke when the coordinator receives an event. The event value is provided as the closure's parameter.
    ///
    /// Handlers registered using this method will receive events for the lifetime of the coordinator.
    /// To create an event listener that can later be cancelled, use ``receiveEvent(_:)``.
    public func handleEvent(_ event: String, handler: @escaping (Payload) -> Void) {
        receiveEvent(event)
            .sink(receiveValue: handler)
            .store(in: &eventHandlers)
    }
    
    private func handleDiff(payload: Payload, baseURL: URL) throws {
        handleEvents(payload: payload)
        let diff = try RootDiff(from: FragmentDecoder(data: payload))
        self.rendered = try self.rendered.merge(with: diff)
        self.document?.merge(with: try Document.parse(self.rendered.buildString()))
    }
    
    private func handleEvents(payload: Payload) {
        guard let events = payload["e"] as? [[Any]] else {
            return
        }
        for event in events {
            guard let name = event[0] as? String,
                  let value = event[1] as? Payload else {
                continue
            }
            eventSubject.send((name, value))
        }
    }
    
    private nonisolated func parseDOM(html: String, baseURL: URL) throws -> Elements {
        let document = try Parser.htmlParser().parseInput(html, baseURL.absoluteString)
        return document.children()
    }
    
    func connect() async {
        if let channel {
            guard !channel.isJoined, !channel.isJoining else { return }
        }
        internalState = .startingConnection
        do {
            try await connectLiveView()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func disconnect() {
        if let channel {
            channel.leave()
        }
        channel = nil
        self.internalState = .notConnected(reconnectAutomatically: false)
        self.document = nil
    }
    
    func reconnect() async {
        self.disconnect()
        await self.connect()
    }
    
    private func extractDOMValues(_ doc: SwiftSoup.Document) throws -> (String, String, String, String) {
        let metaRes = try doc.select("meta[name=\"csrf-token\"]")
        guard !metaRes.isEmpty() else {
            throw LiveConnectionError.initialParseError
        }
        let phxCSRFToken = try metaRes[0].attr("content")
//        let liveReloadEnabled = !(try doc.select("iframe[src=\"/phoenix/live_reload/frame\"]").isEmpty())
        
        let mainDivRes = try doc.select("div[data-phx-main=\"true\"]")
        guard !mainDivRes.isEmpty() else {
            throw LiveConnectionError.initialParseError
        }
        let mainDiv = mainDivRes[0]
        let phxSession = try mainDiv.attr("data-phx-session")
        let phxStatic = try mainDiv.attr("data-phx-static")
//        let phxView = try mainDiv.attr("data-phx-view")
        let phxID = try mainDiv.attr("id")
        
        return (phxCSRFToken, phxSession, phxStatic, phxID)
    }
    
    // todo: don't use Any for the params
    private func connectLiveView() async throws {
        guard let socket = session.socket else { return }
        
        let html: String
        do {
            html = try await session.fetchDOM(url: self.url)
        } catch let error as LiveConnectionError {
            internalState = .connectionFailed(error)
            return
        }
        
        try Task.checkCancellation()
        
        let phxCSRFToken: String, phxSession: String, phxStatic: String, phxID: String
        
        do {
            let doc = try SwiftSoup.parse(html)
            (phxCSRFToken, phxSession, phxStatic, phxID) = try self.extractDOMValues(doc)
        } catch {
            internalState = .connectionFailed(LiveConnectionError.initialParseError)
            return
        }
        
        var connectParams = session.config.connectParams?(self.url) ?? [:]
        connectParams["_mounts"] = 0
        connectParams["_csrf_token"] = phxCSRFToken
        connectParams["_platform"] = "ios"
        
        let params: Payload = [
            "session": phxSession,
            "static": phxStatic,
            "url": self.url.absoluteString,
            "params": connectParams,
        ]
        
        let channel = socket.channel("lv:\(phxID)", params: params)
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
                    Task { @MainActor in
                        await self.session.redirect(redirect)
                    }
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
        self.handleEvents(payload: renderedPayload)
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
