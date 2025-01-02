//
//  LiveViewCoordinator.swift
//
//
//  Created by Carson Katri on 1/6/23.
//

import Foundation
import SwiftUI
import Combine
import LiveViewNativeCore
import AsyncAlgorithms
import OSLog

private let PUSH_TIMEOUT: Double = 30000

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
    
    @_spi(LiveForm) public private(set) weak var session: LiveSessionCoordinator<R>!
    
    var url: URL

    private(set) var liveChannel: LiveViewNativeCore.LiveChannel?
    private var channel: LiveViewNativeCore.Channel?

    @Published var document: LiveViewNativeCore.Document? {
        didSet {
            elementChangedSubjects.removeAll()
            uploadRef = 0
        }
    }
    private var elementChangedSubjects = [NodeRef:ObjectWillChangePublisher]()
    func elementChanged(_ ref: NodeRef) -> ObjectWillChangePublisher {
        guard let subject = elementChangedSubjects[ref] else {
            let newSubject = ObjectWillChangePublisher()
            elementChangedSubjects[ref] = newSubject
            return newSubject
        }
        return subject
    }
    internal let builder = ViewTreeBuilder<R>()

    private(set) internal var eventSubject = PassthroughSubject<(String, Json), Never>()
    private(set) internal var eventHandlers = Set<AnyCancellable>()
    
//    private var eventListener: Channel.EventStream?
    private var eventListenerLoop: Task<(), any Error>?
//    private var statusListener: Channel.StatusStream?
    private var statusListenerLoop: Task<(), any Error>?

    private(set) internal var liveViewModel = LiveViewModel()
    
    private var uploadRef: Int = 0
    func nextUploadRef() -> Int {
        let next = uploadRef
        uploadRef += 1
        return next
    }

    init(session: LiveSessionCoordinator<R>, url: URL) {
        self.session = session
        self.url = url
    }
    
    deinit {
        self.eventListenerLoop?.cancel()
        self.statusListenerLoop?.cancel()
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
    public func pushEvent(type: String, event: String, value: some Encodable, target: Int? = nil) async throws -> [String:Any]? {
        return try await doPushEvent("event", payload: .jsonPayload(json: .object(object: [
            "type": .str(string: type),
            "event": .str(string: event),
            "value": try JsonEncoder().encode(value),
            "cid": target.flatMap({ .numb(number: .posInt(pos: UInt64($0))) }) ?? .null
        ])))
    }
    
    @discardableResult
    public func pushEvent(type: String, event: String, value: Any, target: Int? = nil) async throws -> [String:Any]? {
        return try await doPushEvent("event", payload: .jsonPayload(json: .object(object: [
            "type": .str(string: type),
            "event": .str(string: event),
            "value": try JSONDecoder().decode(Json.self, from: JSONSerialization.data(withJSONObject: value, options: .fragmentsAllowed)),
            "cid": target.flatMap({ .numb(number: .posInt(pos: UInt64($0))) }) ?? .null
        ])))
    }
    
    @discardableResult
    internal func doPushEvent(_ event: String, payload: LiveViewNativeCore.Payload) async throws -> [String:Any]? {
        guard let channel = channel else {
            return nil
        }
        
        guard case .joined = channel.status() else {
            throw LiveSocketError.DisconnectionError
        }
        
        let replyPayload = try await channel.call(event: .user(user: event), payload: payload, timeout: PUSH_TIMEOUT)
        
        return try await handleEventReplyPayload(replyPayload)
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
    public func receiveEvent(_ event: String) -> some Publisher<Json, Never> {
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
    public func handleEvent(_ event: String, handler: @escaping (Json) -> Void) {
        receiveEvent(event)
            .sink(receiveValue: handler)
            .store(in: &eventHandlers)
    }
    
    public func receiveEvent<T>(_ event: String, for type: T.Type = T.self) -> some Publisher<T, Never>
        where T: Decodable
    {
        receiveEvent(event)
            .decode(type: type, decoder: JsonDecoder())
            .catch({ _ in Empty() })
    }

    private func handleDiff(payload: LiveViewNativeCore.Json, baseURL: URL) throws {
        handleEvents(payload)
        try self.document?.mergeFragmentJson(String(data: try JSONEncoder().encode(payload), encoding: .utf8)!)
    }
    
    func handleEventReplyPayload(_ replyPayload: LiveViewNativeCore.Payload) async throws -> [String:Any]? {
        switch replyPayload {
        case let .jsonPayload(json):
            switch json {
            case let .object(object):
                if case let .object(diff) = object["diff"] {
                    try self.handleDiff(payload: .object(object: diff), baseURL: self.url)
                    if case let .object(reply) = diff["r"] {
                        return reply
                    }
                } else if case let .object(redirectObject) = object["live_redirect"],
                          let redirect = LiveRedirect(from: redirectObject, relativeTo: self.url)
                {
                    try await session.redirect(redirect)
                } else if case let .object(redirectObject) = object["redirect"],
                          case let .str(destinationString) = redirectObject["to"],
                          let destination = URL(string: destinationString, relativeTo: self.url)
                {
                    try await session.redirect(.init(kind: .push, to: destination, mode: .replaceTop))
                } else {
                    return nil
                }
            default:
                logger.error("unhandled event reply: \(String(reflecting: replyPayload))")
            }
        default:
            logger.error("unhandled event reply: \(String(reflecting: replyPayload))")
        }
        return nil
    }

    private func handleEvents(_ json: LiveViewNativeCore.Json) {
        guard case let .object(object) = json,
              case let .array(array: events) = object["e"]
        else {
            return
        }
        for case let .array(event) in events {
            guard case let .str(string: name) = event[0] else {
                continue
            }
            eventSubject.send((name, event[1]))
        }
    }

    func bindEventListener() {
        self.eventListenerLoop = Task { [weak self, weak channel] in
            guard let channel else { return }
            let eventListener = channel.eventStream()
            for try await event in eventListener {
                guard let self else { return }
                guard !Task.isCancelled else { return }
                do {
                    switch event.event {
                    case .user(user: "diff"):
                        switch event.payload {
                        case let .jsonPayload(json):
                            try self.handleDiff(payload: json, baseURL: self.url)
                        case .binary:
                            fatalError()
                        }
                    case .user(user: "live_redirect"):
                        guard case let .jsonPayload(json) = event.payload,
                              case let .object(payload) = json,
                              let redirect = LiveRedirect(from: payload, relativeTo: self.url)
                        else { break }
                        try await self.session.redirect(redirect)
                    case .user(user: "live_patch"):
                        guard case let .jsonPayload(json) = event.payload,
                              case let .object(payload) = json,
                              let redirect = LiveRedirect(from: payload, relativeTo: self.url, mode: .patch)
                        else { return }
                        try await self.session.redirect(redirect)
                    case .user(user: "redirect"):
                        guard case let .jsonPayload(json) = event.payload,
                              case let .object(payload) = json,
                              let destination = (payload["to"] as? String).flatMap({ URL.init(string: $0, relativeTo: self.url) })
                        else { return }
                        try await self.session.redirect(.init(kind: .push, to: destination, mode: .replaceTop))
                    default:
                        logger.error("Unhandled event: \(String(describing: event))")
                    }
                } catch {
                    logger.error("Event handling error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func bindDocumentListener() {
        self.document?.on(.changed) { [weak self] nodeRef, nodeData, parent in
            guard let self else { return }
            switch nodeData {
            case .root:
                // when the root changes, update the `NavStackEntry` itself.
                self.objectWillChange.send()
            case .leaf:
                // text nodes don't have their own views, changes to them need to be handled by the parent Text view
                if let parent {
                    self.elementChanged(nodeRef).send()
                } else {
                    self.elementChanged(nodeRef).send()
                }
            case .nodeElement:
                // when a single element changes, send an update only to that element.
                self.elementChanged(nodeRef).send()
            }
        }
    }

    func join(_ liveChannel: LiveViewNativeCore.LiveChannel) {
        self.liveChannel = liveChannel
        let channel = liveChannel.channel()
        self.channel = channel
        
        statusListenerLoop = Task { @MainActor [weak self, unowned channel] in
            let statusListener = channel.statusStream()
            for try await status in statusListener {
                self?.internalState = switch status {
                case .joined:
                    .connected
                case .joining, .waitingForSocketToConnect, .waitingToJoin:
                    .connecting
                case .waitingToRejoin:
                    .reconnecting
                case .leaving, .left, .shuttingDown, .shutDown:
                    .disconnected
                }
            }
        }
        
        self.bindEventListener()
        
        self.document = liveChannel.document()
        self.bindDocumentListener()
        
        switch liveChannel.joinPayload() {
        case let .jsonPayload(.object(payload)):
            self.handleEvents(payload["rendered"]!)
        default:
            fatalError()
        }
        
        self.internalState = .connected
    }
    
    func disconnect() async throws {
        try await self.channel?.leave()
        self.eventListenerLoop = nil
        self.statusListenerLoop = nil
        self.liveChannel = nil
        self.channel = nil
        
        self.internalState = .setup
    }
}
