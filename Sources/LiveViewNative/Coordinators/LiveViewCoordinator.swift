//
//  LiveViewCoordinator.swift
//  
//
//  Created by Carson Katri on 1/6/23.
//

import Foundation
import SwiftPhoenixClient
import SwiftSoup
import SwiftUI
import Combine
import LiveViewNativeCore
import OSLog

private var PUSH_TIMEOUT: Double = 30000

private let logger = Logger(subsystem: "LiveViewNative", category: "LiveViewCoordinator")

/// The live view coordinator manages the connection to a particular LiveView on the backend.
///
/// ## Topics
/// ### LiveView Events
/// - ``pushEvent(type:event:value:target:)``
/// - ``receiveEvent(_:)``
/// - ``handleEvent(_:handler:)``
@MainActor
public class LiveViewCoordinator<R: RootRegistry>: ObservableObject {
    @Published internal private(set) var internalState: LiveSessionState = .setup
    
    var state: LiveSessionState {
        internalState
    }
    
    @_spi(LiveForm) public let session: LiveSessionCoordinator<R>
    var url: URL
    
    private var channel: Channel?
    
    @Published var document: LiveViewNativeCore.Document?
    private var elementChangedSubjects = [NodeRef:ObjectWillChangePublisher]()
    func elementChanged(_ ref: NodeRef) -> ObjectWillChangePublisher {
        guard let subject = elementChangedSubjects[ref] else {
            let newSubject = ObjectWillChangePublisher()
            elementChangedSubjects[ref] = newSubject
            return newSubject
        }
        return subject
    }
    internal var rendered: Root!
    internal let builder = ViewTreeBuilder<R>()
    
    private var currentConnectionToken: ConnectionAttemptToken?
    private var currentConnectionTask: Task<Void, Error>?
    
    private(set) internal var eventSubject = PassthroughSubject<(String, Payload), Never>()
    private(set) internal var eventHandlers = Set<AnyCancellable>()
    
    init(session: LiveSessionCoordinator<R>, url: URL) {
        self.session = session
        self.url = url
        
        self.handleEvent("native_redirect") { [weak self] payload in
            guard let self,
                  let redirect = LiveRedirect(from: payload, relativeTo: self.url)
            else { return }
            Task { [weak session] in
                try await session?.redirect(redirect)
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
    /// - Parameter value: The event value to provide to the backend event handler. The value _must_ be  serializable using `JSONSerialization`.
    /// - Parameter target: The value of the `phx-target` attribute.
    /// - Throws: ``LiveConnectionError/eventError(_:)`` if an error is encountered sending the event or processing it on the backend, `CancellationError` if the coordinator navigates to a different page while the event is being handled
    @discardableResult
    public func pushEvent(type: String, event: String, value: Any, target: Int? = nil) async throws -> [String:Any]? {
        // isValidJSONObject only accepts objects, but we want to check that the value can be serialized as a field of an object
        precondition(JSONSerialization.isValidJSONObject(["a": value]))
        return try await doPushEvent("event", payload: [
            "type": type,
            "event": event,
            "value": value,
            "cid": target as Any
        ])
    }
    
    @discardableResult
    public func pushEvent(type: String, event: String, value: some Encodable, target: Int? = nil) async throws -> [String:Any]? {
        try await pushEvent(
            type: type,
            event: event,
            value: try JSONSerialization.jsonObject(with: JSONEncoder().encode(value)),
            target: target
        )
    }
    
    @discardableResult
    internal func doPushEvent(_ event: String, payload: Payload) async throws -> [String:Any]? {
        guard let channel = channel else {
            return nil
        }
        
        let token = self.currentConnectionToken

        let replyPayload: [String:Any] = try await withCheckedThrowingContinuation({ [weak channel] continuation in
            guard channel?.isJoined == true else {
                return continuation.resume(throwing: LiveConnectionError.viewCoordinatorReleased)
            }
            channel?.push(event, payload: payload, timeout: PUSH_TIMEOUT)
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
            try self.handleDiff(payload: diffPayload, baseURL: self.url)
            if let reply = diffPayload["r"] as? [String:Any] {
                return reply
            }
        } else if let redirect = (replyPayload["live_redirect"] as? Payload).flatMap({ LiveRedirect(from: $0, relativeTo: self.url) }) {
            try await session.redirect(redirect)
        } else if let redirect = (replyPayload["redirect"] as? Payload),
                  let destination = (redirect["to"] as? String).flatMap({ URL.init(string: $0, relativeTo: self.url) })
        {
            try await session.redirect(.init(kind: .push, to: destination, mode: .replaceTop))
        }
        return nil
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
    ///     @LiveContext<EmptyRegistry> var context
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
    
    func connect(domValues: LiveSessionCoordinator<R>.DOMValues, redirect: Bool) async throws {
        await self.disconnect()
        
        self.internalState = .connecting
        
        guard let socket = session.socket else { return }
        
        var connectParams = session.configuration.connectParams?(self.url) ?? [:]
        connectParams["_mounts"] = 0
        connectParams["_format"] = "swiftui"
        connectParams["_csrf_token"] = domValues.phxCSRFToken
        connectParams["_interface"] = LiveSessionCoordinator<R>.platformParams

        let params: Payload = [
            "session": domValues.phxSession,
            "static": domValues.phxStatic,
            (redirect ? "redirect": "url"): self.url.absoluteString,
            "params": connectParams,
        ]

        let channel = socket.channel("lv:\(domValues.phxID)", params: params)
        self.channel = channel
        channel.onError { message in
            logger.error("[Channel] Error: \(String(describing: message))")
        }
        channel.onClose { message in
            logger.info("[Channel] Closed")
        }
        channel.on("diff") { [weak self, weak channel] message in
            Task { @MainActor in
                guard let self,
                      channel === self.channel
                else { return }
                try! self.handleDiff(payload: message.payload, baseURL: self.url)
            }
        }
        channel.on("live_redirect") { [weak self] message in
            Task {
                guard let self,
                      let redirect = LiveRedirect(from: message.payload, relativeTo: self.url)
                else { return }
                try await self.session.redirect(redirect)
            }
        }
        channel.on("live_patch") { [weak self] message in
            Task {
                guard let self,
                      let redirect = LiveRedirect(from: message.payload, relativeTo: self.url, mode: .patch)
                else { return }
                try await self.session.redirect(redirect)
            }
        }
        channel.on("redirect") { [weak self] message in
            Task {
                guard let self,
                      let destination = (message.payload["to"] as? String).flatMap({ URL.init(string: $0, relativeTo: self.url) })
                else { return }
                try await self.session.redirect(.init(kind: .push, to: destination, mode: .replaceTop))
            }
        }
        channel.on("phx_close") { [weak self, weak channel] message in
            Task { @MainActor in
                guard channel === self?.channel else { return }
                self?.internalState = .disconnected
            }
        }
        
        let joinTask = Task {
            for try await joinResult in join(channel: channel) {
                switch joinResult {
                case .rendered(let payload):
                    await MainActor.run {
                        self.handleJoinPayload(renderedPayload: payload)
                        self.internalState = .connected
                    }
                case .redirect(let liveRedirect):
                    self.url = liveRedirect.to
                    try await self.connect(domValues: domValues, redirect: true)
                }
            }
        }
        
        channel.onClose { _ in
            joinTask.cancel()
        }
    }
    
    func disconnect() async {
        if let channel,
           !channel.isClosed
        {
            await withCheckedContinuation { continuation in
                channel.leave()
                    .receive("ok") { _ in
                        continuation.resume()
                    }
            }
        }
        await MainActor.run { [weak self] in
            self?.channel = nil
            self?.internalState = .disconnected
        }
    }
    
    enum JoinResult {
        case rendered(Payload)
        case redirect(LiveRedirect)
    }

    private func join(channel: Channel) -> AsyncThrowingStream<JoinResult, Error> {
        return AsyncThrowingStream<JoinResult, Error> { [weak channel] (continuation: AsyncThrowingStream<JoinResult, Error>.Continuation) -> Void in
            channel?.join()
                .receive("ok") { [weak self, weak channel] message in
                    guard let channel else {
                        continuation.finish(throwing: LiveConnectionError.viewCoordinatorReleased)
                        return
                    }
                    guard self != nil else {
                        // leave the channel so we don't get any more messages/automatic rejoins
                        if channel.isJoined {
                            channel.leave()
                        }
                        continuation.finish(throwing: LiveConnectionError.viewCoordinatorReleased)
                        return
                    }
                    let renderedPayload = (message.payload["rendered"] as! Payload)
                    continuation.yield(.rendered(renderedPayload))
                }
                .receive("error") { [weak self, weak channel] message in
                    guard channel != nil else {
                        continuation.finish(throwing: LiveConnectionError.viewCoordinatorReleased)
                        return
                    }
                    
                    Task { [weak self] in
                        guard let self else {
                            continuation.finish(throwing: LiveConnectionError.viewCoordinatorReleased)
                            return
                        }

                        switch message.payload["reason"] as? String {
                        case "unauthorized", "stale":
                            await self.session.reconnect()
                        default:
                            await self.disconnect()
                        }

                        if let redirect = (message.payload["live_redirect"] as? Payload).flatMap({ LiveRedirect(from: $0, relativeTo: self.url) }) {
                            continuation.yield(.redirect(redirect))
                        } else {
                            continuation.finish(throwing: LiveConnectionError.joinError(message))
                        }
                    }
                }
            channel?.onClose { _ in
                continuation.finish()
            }
            continuation.onTermination = { [weak channel] termination in
                channel?.leave()
            }
        }
    }
    
    private func handleJoinPayload(renderedPayload: Payload) {
        // todo: what should happen if decoding or parsing fails?
        self.rendered = try! Root(from: FragmentDecoder(data: renderedPayload))
        self.document = try! LiveViewNativeCore.Document.parse(rendered.buildString())
        self.document?.on(.changed) { [unowned self] doc, nodeRef in
            switch doc[nodeRef].data {
            case .root:
                // when the root changes, update the `NavStackEntry` itself.
                self.objectWillChange.send()
            case .leaf:
                // text nodes don't have their own views, changes to them need to be handled by the parent Text view
                if let parent = doc.getParent(nodeRef) {
                    self.elementChanged(nodeRef).send()
                } else {
                    self.elementChanged(nodeRef).send()
                }
            case .element:
                // when a single element changes, send an update only to that element.
                self.elementChanged(nodeRef).send()
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
