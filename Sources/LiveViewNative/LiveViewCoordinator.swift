//
//  LiveViewCoordinator.swift
// LiveViewNative
//
//  Created by Brian Cardarella on 4/12/21.
//

import Foundation
import SwiftSoup
import SwiftUI
import SwiftPhoenixClient
import Combine
import OSLog
import LiveViewNativeCore

private var PUSH_TIMEOUT: Double = 30000

private let logger = Logger(subsystem: "LiveViewNative", category: "LiveViewCoordinator")

/// The live view coordinator object handles connecting to Phoenix LiveView on the backend, managing the websocket connection, and transmitting/handling events.
@MainActor
public class LiveViewCoordinator<R: CustomRegistry>: ObservableObject {
    @Published internal private(set) var internalState: InternalState = .notConnected(reconnectAutomatically: false)
    /// The current state of the live view connection.
    public var state: State {
        internalState.publicState
    }
    
    /// The first URL this live view was connected to.
    public let initialURL: URL
    /// The current URL this live view is connected to.
    ///
    /// - Note: If you need to use the URL in, e.g., a view with a custom action, you should generally prefer the context's ``LiveContext/url`` because `currentURL` will change upon live navigation and may not reflect the URL of the page your view is actually on.
    public private(set) var currentURL: URL
    
    internal let config: LiveViewConfiguration
    
    // Values extracted from the DOM
    private var phxSession: String = ""
    private var phxStatic: String = ""
    private var phxView: String = ""
    private var phxID: String = ""
    private var phxCSRFToken: String = ""
    
    // Socket connection
    private var socket: Socket?
    private var channel: Channel?
    
    @Published private(set) var document: LiveViewNativeCore.Document? = nil
    let elementChanged = PassthroughSubject<NodeRef, Never>()
    private var rendered: Root!
    
    private var liveReloadEnabled: Bool = false
    private var liveReloadSocket: Socket?
    private var liveReloadChannel: Channel?
    
    internal let builder = ViewTreeBuilder<R>()
    
    internal let replaceRedirectSubject = PassthroughSubject<(URL, URL), Never>()
    private var currentConnectionToken: ConnectionAttemptToken?
    private var currentConnectionTask: Task<Void, Error>?
    
    private var eventHandlers: [String: (Payload) -> Void] = [:]
    
    /// Creates a new coordinator with a custom registry.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter config: The configuration for this coordinator.
    /// - Parameter customRegistryType: The type of the registry of custom views this coordinator will use when building the SwiftUI view tree from the DOM. This can generally be inferred automatically.
    public init(_ url: URL, config: LiveViewConfiguration = .init(), customRegistryType: R.Type = R.self) {
        self.initialURL = url
        self.currentURL = url
        self.config = config
    }
    
    /// Creates a new coordinator without a custom registry.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter config: The configuration for this coordinator.
    public convenience init(_ url: URL, config: LiveViewConfiguration = .init()) where R == EmptyRegistry {
        self.init(url, config: config, customRegistryType: EmptyRegistry.self)
    }
    
    /// Connects this coordinator to the LiveView channel.
    ///
    /// This function is a no-op unless ``state-swift.property`` is ``State-swift.enum/notConnected``.
    ///
    /// This is an async function which completes when the connection has been established or failed.
    public func connect() async {
        guard case .notConnected = state else {
            return
        }
        
        // TODO: cancellation and our token system might not both be necessary
        currentConnectionTask?.cancel()
        let token = ConnectionAttemptToken()
        currentConnectionToken = token
        do {
            try await self.doConnect(token: token)
        } catch {
            // doConnect only throws CancellationErrors, which we swallow
        }
    }
    
    private func doConnect(token: ConnectionAttemptToken) async throws {
        guard case .notConnected = state else {
            return
        }
        
        logger.debug("Connecting to \(self.currentURL.absoluteString)")
        
        internalState = .startingConnection
        // in case we're reconnecting, reset the document so nothing gets stale elements
        document = nil
        
        let html: String
        do {
            html = try await fetchDOM()
        } catch let error as Error {
            internalState = .connectionFailed(error)
            return
        }
        
        try Task.checkCancellation()
        guard self.currentConnectionToken === token else {
            throw CancellationError()
        }
        
        do {
            let doc = try SwiftSoup.parse(html)
            try self.extractDOMValues(doc)
        } catch {
            internalState = .connectionFailed(Error.initialParseError)
            return
        }
        
        if socket == nil {
            do {
                try await self.connectSocket()
            } catch let error as Error {
                internalState = .connectionFailed(error)
                return
            }
        }
        
        try Task.checkCancellation()
        guard self.currentConnectionToken === token else {
            throw CancellationError()
        }
        
        do {
            try await self.connectLiveView(token: token)
        } catch let error as Error {
            internalState = .connectionFailed(error)
        }
    }
    
    private func disconnect() {
        // when deliberately disconnect, don't let pending connections continue
        internalState = .notConnected(reconnectAutomatically: false)
        channel?.leave()
        channel = nil
    }
    
    @_spi(NarwinChat)
    public func reconnect() async {
        disconnect()
        await connect()
    }
    
    func navigateTo(url: URL, replace: Bool = false) async {
        guard self.currentURL != url else { return }
        let oldURL = self.currentURL
        self.currentURL = url
        // TODO: once we only target iOS 16+, remove replaceRedirectSubject. the NavigationCoordinator's url array will be the sole source of truth, and NavStackEntryViews will get their URLs from that
        if replace {
            replaceRedirectSubject.send((oldURL, url))
        }
        await reconnect()
    }
    
    @_spi(NarwinChat)
    public func replaceTopNavigationEntry(with url: URL) async {
        await navigateTo(url: url, replace: true)
    }
    
    @ViewBuilder
    func viewTree() -> some View {
        if let document {
            builder.fromNodes(document[document.root()].children(), coordinator: self, url: currentURL)
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
                    continuation.resume(throwing: Error.eventError(message))
                }
        })
        
        guard currentConnectionToken === token else {
            // TODO: maybe this should just silently fail?
            throw CancellationError()
        }
        
        if let diffPayload = replyPayload["diff"] as? Payload {
            do {
                try self.handleDiff(payload: diffPayload, baseURL: self.currentURL)
            } catch {
                fatalError("todo")
            }
        } else if config.liveRedirectsEnabled,
                  let liveRedirect = replyPayload["live_redirect"] as? Payload {
            self.handleLiveRedirect(liveRedirect)
        }
    }
    
    private func fetchDOM() async throws -> String {
        let data: Data
        let resp: URLResponse
        do {
            (data, resp) = try await config.urlSession.data(from: currentURL)
        } catch {
            throw Error.initialFetchError(error)
        }
            
        if (resp as! HTTPURLResponse).statusCode == 200,
           let html = String(data: data, encoding: .utf8) {
            return html
        } else {
            throw Error.initialFetchUnexpectedResponse(resp)
        }
    }
    
    private func extractDOMValues(_ doc: SwiftSoup.Document) throws -> Void {
        let metaRes = try doc.select("meta[name=\"csrf-token\"]")
        guard !metaRes.isEmpty() else {
            throw Error.initialParseError
        }
        self.phxCSRFToken = try metaRes[0].attr("content")
        self.liveReloadEnabled = !(try doc.select("iframe[src=\"/phoenix/live_reload/frame\"]").isEmpty())
        
        let mainDivRes = try doc.select("div[data-phx-main=\"true\"]")
        guard !mainDivRes.isEmpty() else {
            throw Error.initialParseError
        }
        let mainDiv = mainDivRes[0]
        self.phxSession = try mainDiv.attr("data-phx-session")
        self.phxStatic = try mainDiv.attr("data-phx-static")
        self.phxView = try mainDiv.attr("data-phx-view")
        self.phxID = try mainDiv.attr("id")
    }
    
    private func handleDiff(payload: Payload, baseURL: URL) throws {
        if config.eventHandlersEnabled,
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
        self.document!.merge(with: try Document.parse(self.rendered.buildString()))
    }
    
    private nonisolated func parseDOM(html: String, baseURL: URL) throws -> Elements {
        // we parse the DOM as XML rather than HTML, because we don't want it to apply browser-specific HTML transformations
        // such as <image> -> <img>
        let document = try Parser.xmlParser().parseInput(html, baseURL.absoluteString)
        return document.children()
    }

    private func connectSocket() async throws {
        let cookies = HTTPCookieStorage.shared.cookies(for: self.currentURL)
        
        let configuration = config.urlSession.configuration
        for cookie in cookies! {
            configuration.httpCookieStorage!.setCookie(cookie)
        }
    
        let _: Void = try await withCheckedThrowingContinuation { continuation in
            self.internalState = .awaitingSocketConnection(continuation)
            doConnectSocket(urlSessionConfiguration: configuration)
        }
        
        if liveReloadEnabled {
            Task {
                await self.connectLiveReloadSocket(urlSessionConfiguration: configuration)
            }
        }
    }
    
    private func doConnectSocket(urlSessionConfiguration config: URLSessionConfiguration) {
        var wsEndpoint = URLComponents(url: currentURL, resolvingAgainstBaseURL: true)!
        wsEndpoint.scheme = currentURL.scheme == "https" ? "wss" : "ws"
        wsEndpoint.path = "/live/websocket"
        let socket = Socket(endPoint: wsEndpoint.string!, transport: { URLSessionTransport(url: $0, configuration: config) }, paramsClosure: {["_csrf_token": self.phxCSRFToken]})
        self.socket = socket
        socket.onOpen { [weak self] in
            guard let self = self else {
                socket.disconnect()
                return
            }
            logger.debug("[Socket] Opened")
            if case .awaitingSocketConnection(let continuation) = self.internalState {
                continuation.resume()
            }
        }
        socket.onClose { logger.debug("[Socket] Closed") }
        socket.onError { [weak self] (error) in
            guard let self = self else {
                socket.disconnect()
                return
            }
            logger.error("[Socket] Error: \(String(describing: error))")
            if case .awaitingSocketConnection(let continuation) = self.internalState {
                continuation.resume(throwing: Error.socketError(error))
            } else {
                Task { @MainActor in
                    self.internalState = .connectionFailed(.socketError(error))
                }
            }
        }
        socket.logger = { message in logger.debug("[Socket] \(message)") }
        socket.connect()
    }
    
    private func connectLiveReloadSocket(urlSessionConfiguration: URLSessionConfiguration) async {
        logger.debug("[LiveReload] attempting to connect...")

        var liveReloadEndpoint = URLComponents(url: currentURL, resolvingAgainstBaseURL: true)!
        liveReloadEndpoint.scheme = currentURL.scheme == "https" ? "wss" : "ws"
        liveReloadEndpoint.path = "/phoenix/live_reload/socket"
        self.liveReloadSocket = Socket(endPoint: liveReloadEndpoint.string!, transport: {
            URLSessionTransport(url: $0, configuration: urlSessionConfiguration)
        })
        liveReloadSocket!.connect()
        self.liveReloadChannel = liveReloadSocket!.channel("phoenix:live_reload")
        self.liveReloadChannel!.join().receive("ok") { msg in
            logger.debug("[LiveReload] connected to channel")
        }.receive("error") { msg in
            logger.debug("[LiveReload] error connecting to channel: \(msg.payload)")
        }
        self.liveReloadChannel!.on("assets_change") { [unowned self] _ in
            logger.debug("[LiveReload] assets changed, reloading")
            Task {
                // need to fully reconnect (rather than just re-join channel) because the elixir code reloader only triggers on http reqs
                await self.reconnect()
            }
        }
    }
    
    // todo: don't use Any for the params
    private func connectLiveView(token: ConnectionAttemptToken) async throws {
        guard let socket = socket else {
            return
        }
        
        var connectParams = config.connectParams?(currentURL) ?? [:]
        connectParams["_mounts"] = 0
        connectParams["_csrf_token"] = phxCSRFToken
        connectParams["_platform"] = "ios"
        
        let params: Payload = [
            "session": phxSession,
            "static": phxStatic,
            "url": currentURL.absoluteString,
            "params": connectParams,
        ]
        
        let channel = socket.channel("lv:\(self.phxID)", params: params)
        self.channel = channel
        channel.onError { message in
            logger.error("[Channel] Error: \(String(describing: message))")
        }
        channel.onClose { message in
            logger.info("[Channel] Closed")
        }
        channel.on("diff") { message in
            guard self.currentConnectionToken === token else {
                // if we've received a message for a now-stale connection, leave its channel
                channel.leave()
                return
            }
            Task { @MainActor in
                try! self.handleDiff(payload: message.payload, baseURL: self.currentURL)
            }
        }
        
        let renderedPayload: Payload = try await withCheckedThrowingContinuation { continuation in
            self.internalState = .awaitingJoinResponse(continuation)
            setupChannelJoinHandlers(channel: channel, token: token)
        }
        
        Task { @MainActor in
            handleJoinPayload(renderedPayload: renderedPayload)
        }
    }
    
    private func setupChannelJoinHandlers(channel: Channel, token: ConnectionAttemptToken) {
        channel.join()
            .receive("ok") { [weak self] message in
                guard let self = self,
                      self.currentConnectionToken === token else {
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
                
                guard let self = self,
                      self.currentConnectionToken === token else {
                    if case .awaitingJoinResponse(let continuation) = self?.internalState {
                        continuation.resume(throwing: CancellationError())
                    }
                    return
                }
                
                if self.config.liveRedirectsEnabled,
                   let redirect = message.payload["live_redirect"] as? Payload {
                    self.handleLiveRedirect(redirect)
                } else {
                    if case .awaitingJoinResponse(let continuation) = self.internalState {
                        continuation.resume(throwing: Error.joinError(message))
                    } else if self.internalState.reconnectAutomatically {
                        // TODO: reconnectAutomatically is a bit of a misnomer here,
                        Task { @MainActor in
                            self.internalState = .connectionFailed(.joinError(message))
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
        self.document!.on(.changed) { [unowned self] doc, nodeRef in
            // text nodes don't have their own views, changes to them need to be handled by the parent PhxText view
            if case .leaf(_) = doc[nodeRef].data,
               let parent = doc.getParent(nodeRef) {
                self.elementChanged.send(parent)
            } else {
                self.elementChanged.send(nodeRef)
            }
        }
    }
    
    private func handleLiveRedirect(_ payload: Payload) {
        guard let dest = payload["to"] as? String else {
            return
        }
        // TODO: rather than kicking off a new task, we should continue the existing one with the redirect
        Task {
            await self.replaceTopNavigationEntry(with: URL(string: dest, relativeTo: self.currentURL)!)
        }
        if case .awaitingJoinResponse(let continuation) = self.internalState {
            continuation.resume(throwing: CancellationError())
        }
    }
    
    // Non-final API, for internal use only.
    @_spi(NarwinChat)
    public func handleEvent(_ name: String, handler: @escaping (Payload) -> Void) {
        precondition(!eventHandlers.keys.contains(name))
        eventHandlers[name] = handler
    }
}

extension LiveViewCoordinator {
    // The internal state enum stores more details associated with particular states but that we don't want publicly exposed.
    enum InternalState {
        case notConnected(reconnectAutomatically: Bool)
        case startingConnection
        case awaitingSocketConnection(CheckedContinuation<Void, Swift.Error>)
        case awaitingJoinResponse(CheckedContinuation<Payload, Swift.Error>)
        case connected
        case connectionFailed(Error)
        
        var publicState: State {
            switch self {
            case .notConnected(reconnectAutomatically: _):
                return .notConnected
            case .startingConnection, .awaitingSocketConnection(_), .awaitingJoinResponse(_):
                return .connecting
            case .connected:
                return .connected
            case .connectionFailed(let error):
                return .connectionFailed(error)
            }
        }
        
        var reconnectAutomatically: Bool {
            switch self {
            case .notConnected(reconnectAutomatically: let b):
                return b
            case .startingConnection, .awaitingSocketConnection(_), .awaitingJoinResponse(_):
                // connection attempt tokens should make this unreachable, but just in case
                return false
            case .connected:
                //
                return false
            case .connectionFailed(_):
                // if we've previously encountered and error, and SwiftPhoenixClient automatically tries to rejoin the channel
                // and it succeeds, we accept the join
                return true
            }
        }
    }
    /// The live view connection state.
    public enum State {
        /// The coordinator has not yet connected to the live view.
        case notConnected
        /// The coordinator is attempting to connect.
        case connecting
        /// The coordinator has connected and the view tree can be rendered.
        case connected
        // todo: disconnected state?
        /// The coordinator failed to connect and produced the given error.
        case connectionFailed(Error)
    }
}

extension LiveViewCoordinator {
    public enum Error: Swift.Error {
        case initialFetchError(Swift.Error)
        case initialFetchUnexpectedResponse(URLResponse)
        /// An error encountered when parsing the initial HTML.
        case initialParseError
        case socketError(Swift.Error)
        case joinError(Message)
        case eventError(Message)
        
        var localizedDescription: String {
            switch self {
            case .initialFetchError(let error):
                return "initialFetchError(\(error))"
            case .initialFetchUnexpectedResponse(let resp):
                return "initialFetchUnexpectedResponse(\(resp))"
            case .initialParseError:
                return "initialParseError"
            case .socketError(let error):
                return "socketError(\(error))"
            case .joinError(let message):
                return "joinError(\(message.payload))"
            case .eventError(let message):
                return "eventError(\(message.payload))"
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
