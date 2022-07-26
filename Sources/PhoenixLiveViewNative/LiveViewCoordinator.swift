//
//  LiveViewCoordinator.swift
//  PhoenixLiveViewNative
//
//  Created by Brian Cardarella on 4/12/21.
//

import Foundation
import SwiftSoup
import SwiftUI
import SwiftPhoenixClient
import Combine
import OSLog

private var PUSH_TIMEOUT: Double = 30000

private let logger = Logger(subsystem: "LiveViewNative", category: "LiveViewCoordinator")

/// The live view coordinator object handles connecting to Phoenix LiveView on the backend, managing the websocket connection, and transmitting/handling events.
@MainActor
public class LiveViewCoordinator<R: CustomRegistry>: ObservableObject {
    /// The current state of the live view connection.
    @Published public private(set) var state: State = .notConnected
    
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
    
    @Published internal var elements: Elements? = nil
    private var rendered: Root!
    
    private var liveReloadEnabled: Bool = false
    private var liveReloadSocket: Socket?
    private var liveReloadChannel: Channel?
    
    internal let builder = ViewTreeBuilder<R>()
    
    internal let replaceRedirectSubject = PassthroughSubject<(URL, URL), Never>()
    private var currentConnectionToken: ConnectionAttemptToken?
    private var currentConnectionTask: Task<Void, Error>?
    
    /// Creates a new coordinator with a custom registry.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter config: The configuration for this coordinator.
    /// - Parameter customRegistryType: The type of the registry of custom views this coordinator will use when building the SwiftUI view tree from the DOM. This can generally be inferred automatically.
    public nonisolated init(_ url: URL, config: LiveViewConfiguration = .init(), customRegistryType: R.Type = R.self) {
        self.initialURL = url
        self.currentURL = url
        self.config = config
    }
    
    /// Creates a new coordinator without a custom registry.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter config: The configuration for this coordinator.
    public nonisolated convenience init(_ url: URL, config: LiveViewConfiguration = .init()) where R == EmptyRegistry {
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
        
        state = .connecting
        // in case we're reconnecting, reset the elements so nothing gets stale elements
        elements = nil
        
        let html: String
        do {
            html = try await fetchDOM()
        } catch let error as Error {
            state = .connectionFailed(error)
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
            self.state = .connectionFailed(Error.initialParseError)
            return
        }
        
        if socket == nil {
            do {
                try await self.connectSocket()
            } catch let error as Error {
                self.state = .connectionFailed(error)
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
            self.state = .connectionFailed(error)
        }
    }
    
    private func reconnect() async {
        state = .notConnected
        channel = nil
        liveReloadChannel = nil
        await connect()
    }
    
    func navigateTo(url: URL, replace: Bool = false) async {
        guard self.currentURL != url else { return }
        let oldURL = self.currentURL
        self.currentURL = url
        if replace {
            replaceRedirectSubject.send((oldURL, url))
        }
        await reconnect()
    }
    
    @ViewBuilder
    func viewTree() -> some View {
        if let elements = elements {
            builder.fromElements(elements, coordinator: self, url: currentURL)
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

        let diffPayload = try await withCheckedThrowingContinuation({ continuation in
            channel.push(event, payload: payload, timeout: PUSH_TIMEOUT)
                .receive("ok") { reply in
                    continuation.resume(returning: reply.payload["diff"] as? Payload)
                }
                .receive("error") { message in
                    continuation.resume(throwing: Error.eventError(message))
                }
        })
        
        guard currentConnectionToken === token else {
            // TODO: maybe this should just silently fail?
            throw CancellationError()
        }
        
        if let diffPayload = diffPayload,
           let elements = try? self.handleDiff(payload: diffPayload) {
            self.elements = elements
        }
    }
    
    private func fetchDOM() async throws -> String {
        let (data, resp) = try await config.urlSession.data(from: currentURL)
        if (resp as! HTTPURLResponse).statusCode == 200,
           let html = String(data: data, encoding: .utf8) {
            return html
        } else {
            throw Error.other(resp)
        }
    }
    
    private func extractDOMValues(_ doc: Document) throws -> Void {
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
    
    private func handleDiff(payload: Payload) throws -> Elements {
        let diff = try RootDiff(from: FragmentDecoder(data: payload))
        self.rendered = try self.rendered.merge(with: diff)
        return try self.parseDOM(html: self.rendered.buildString())
    }
    
    private nonisolated func parseDOM(html: String) throws -> Elements {
        let document = try SwiftSoup.parseBodyFragment(html)
        return try document.select("body")[0].children()
    }

    private func connectSocket() async throws {
        let cookies = HTTPCookieStorage.shared.cookies(for: self.currentURL)
        
        let configuration = config.urlSession.configuration
        for cookie in cookies! {
            configuration.httpCookieStorage!.setCookie(cookie)
        }
    
        let _: Void = try await withCheckedThrowingContinuation { continuation in
            var wsEndpoint = URLComponents(url: currentURL, resolvingAgainstBaseURL: true)!
            wsEndpoint.scheme = currentURL.scheme == "https" ? "wss" : "ws"
            wsEndpoint.path = "/live/websocket"
            self.socket = Socket(endPoint: wsEndpoint.string!, transport: { URLSessionTransport(url: $0, configuration: configuration) }, paramsClosure: {["_csrf_token": self.phxCSRFToken]})
            socket!.onOpen {
                logger.debug("[Socket] Opened")
                continuation.resume()
            }
            socket!.onClose { logger.debug("[Socket] Closed") }
            socket!.onError { (error) in
                logger.error("[Socket] Error: \(String(describing: error))")
                // TODO: can this be called multiple times? if so, we shouldn't resume the continuation here
                continuation.resume(throwing: Error.socketError(error))
            }
            socket!.logger = { message in logger.debug("[Socket] \(message)") }
            socket!.connect()
        }
        
        if liveReloadEnabled {
            Task {
                await self.connectLiveReloadSocket(urlSessionConfiguration: configuration)
            }
        }
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
        connectParams["_native"] = true
        
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
            print("[Channel] Closed")
        }
        channel.on("diff") { message in
            guard self.currentConnectionToken === token else {
                return
            }
            Task { @MainActor in
                self.elements = try! self.handleDiff(payload: message.payload)
            }
        }
        
        // the let _: Void is necessary because otherwise the return type can't be inferred
        let _: Void = try await withCheckedThrowingContinuation { continuation in
            channel.join()
                .receive("ok") { message in
                    guard self.currentConnectionToken === token else {
                        continuation.resume(throwing: CancellationError())
                        return
                    }
                    let renderedPayload = (message.payload["rendered"] as! Payload)
                    // todo: what should happen if decoding or parsing fails?
                    Task {
                        self.rendered = try! Root(from: FragmentDecoder(data: renderedPayload))
                        let elements = try! self.parseDOM(html: self.rendered.buildString())
                        self.state = .connected
                        self.elements = elements
                        continuation.resume()
                    }
                }
                .receive("error") { message in
                    // leave the channel, otherwise the it'll continue retrying indefinitely
                    // we want to control the retry behavior ourselves, so just leave the channel
                    channel.leave()
                    continuation.resume(throwing: Error.joinError(message))
                }
        }
    }
}

extension LiveViewCoordinator {
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
        /// An error encountered when parsing the initial HTML.
        case initialParseError
        case other(URLResponse)
        case socketError(Swift.Error)
        case joinError(Message)
        case eventError(Message)
        
        var localizedDescription: String {
            switch self {
            case .initialParseError:
                return "initialParseError"
            case .other(let resp):
                return "other(\(resp))"
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
