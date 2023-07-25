//
//  LiveSessionCoordinator.swift
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

private let logger = Logger(subsystem: "LiveViewNative", category: "LiveSessionCoordinator")

/// The session coordinator object handles the initial connection, as well as navigation.
///
/// ## Topics
/// ### Create a Coordinator
/// - ``init(_:config:)``
/// - ``init(_:config:customRegistryType:)``
/// ### Observing Session State
/// - ``state``
/// - ``url``
/// ### Managing the Session
/// - ``connect()``
/// ### Supporting Types
/// - ``LiveSessionState``
/// - ``LiveConnectionError``
@MainActor
public class LiveSessionCoordinator<R: RootRegistry>: ObservableObject {
    @Published internal private(set) var internalState: InternalState = .notConnected(reconnectAutomatically: false)
    /// The current state of the live view connection.
    public var state: LiveSessionState {
        internalState.publicState
    }
    
    /// The current URL this live view is connected to.
    public private(set) var url: URL
    
    @Published var navigationPath = [LiveNavigationEntry<R>]()
    private(set) var rootCoordinator: LiveViewCoordinator<R>!
    
    internal let config: LiveSessionConfiguration
    
    // Values extracted from the DOM
    var phxSession: String = ""
    var phxStatic: String = ""
    var phxView: String = ""
    var phxID: String = ""
    var phxCSRFToken: String = ""
    
    // Socket connection
    var socket: Socket?
    
    var liveReloadEnabled: Bool = false
    private var liveReloadSocket: Socket?
    private var liveReloadChannel: Channel?
    
    private var cancellables = Set<AnyCancellable>()
    
    var isMounted: Bool = false
    
    public convenience init(_ host: some LiveViewHost, config: LiveSessionConfiguration = .init(), customRegistryType: R.Type = R.self) {
        self.init(host.url, config: config, customRegistryType: customRegistryType)
    }
    
    /// Creates a new coordinator with a custom registry.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter config: The configuration for this coordinator.
    /// - Parameter customRegistryType: The type of the registry of custom views this coordinator will use when building the SwiftUI view tree from the DOM. This can generally be inferred automatically.
    public init(_ url: URL, config: LiveSessionConfiguration = .init(), customRegistryType _: R.Type = R.self) {
        self.url = url.appending(path: "").absoluteURL
        self.config = config
        self.rootCoordinator = .init(session: self, url: self.url)
        self.$internalState.sink { state in
            if case .connected = state {
                Task { [weak self] in
                    await self?.rootCoordinator.connect()
                }
            }
        }.store(in: &cancellables)
        $navigationPath.scan(([LiveNavigationEntry<R>](), [LiveNavigationEntry<R>]()), { ($0.1, $1) }).sink { prev, next in
            if prev.count > next.count {
                let last = next.last ?? .init(url: self.url, coordinator: self.rootCoordinator)
                if last.coordinator.url != last.url {
                    last.coordinator.url = last.url
                    Task {
                        await last.coordinator.reconnect()
                    }
                }
            }
        }.store(in: &cancellables)
        $navigationPath.sink { entries in
            guard let entry = entries.last else { return }
            Task {
                // If the coordinator is not connected to the right URL, update it.
                if entry.coordinator.url != entry.url {
                    entry.coordinator.url = entry.url
                    await entry.coordinator.reconnect()
                } else {
                    await entry.coordinator.connect()
                }
            }
        }.store(in: &cancellables)
    }
    
    /// Creates a new coordinator without a custom registry.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter config: The configuration for this coordinator.
    public convenience init(_ url: URL, config: LiveSessionConfiguration = .init()) where R == EmptyRegistry {
        self.init(url, config: config, customRegistryType: EmptyRegistry.self)
    }
    
    /// Connects this coordinator to the LiveView channel.
    ///
    /// You generally do not call this function yourself. It is called automatically when the ``LiveView`` appears.
    ///
    /// This function is a no-op unless ``state`` is ``LiveSessionState/notConnected``.
    ///
    /// This is an async function which completes when the connection has been established or failed.
    public func connect() async {
        guard case .notConnected = state else {
            return
        }
        
        do {
            try await self.doConnect()
        } catch {
            // doConnect only throws CancellationErrors, which we swallow
        }
    }
    
    private func doConnect() async throws {
        guard case .notConnected = state else {
            return
        }
        
        logger.debug("Connecting to \(self.url.absoluteString)")
        
        internalState = .startingConnection
        
        let html: String
        do {
            html = try await fetchDOM(url: self.url)
        } catch let error as LiveConnectionError {
            internalState = .connectionFailed(error)
            return
        }
        
        try Task.checkCancellation()
        
        do {
            let doc = try SwiftSoup.parse(html)
            try self.extractDOMValues(doc)
        } catch {
            internalState = .connectionFailed(error)
            return
        }
        
        if socket == nil {
            do {
                try await self.connectSocket()
            } catch let error as LiveConnectionError {
                internalState = .connectionFailed(error)
                return
            }
        }
    }
    
    private func disconnect() {
        self.rootCoordinator.disconnect()
        navigationPath.removeAll()
        self.socket?.disconnect()
        self.socket = nil
        // when deliberately disconnect, don't let pending connections continue
        internalState = .notConnected(reconnectAutomatically: false)
    }
    
    /// Forces the session to disconnect then connect.
    ///
    /// All state will be lost when the reload occurs, as an entirely new LiveView is mounted.
    ///
    /// This can be used to force the LiveView to reset, for example after an unrecoverable error occurs.
    public func reconnect() async {
        disconnect()
        await connect()
        await self.rootCoordinator.reconnect()
    }
    
    func fetchDOM(url: URL) async throws -> String {
        let data: Data
        let resp: URLResponse
        do {
            (data, resp) = try await config.urlSession.data(from: url)
        } catch {
            throw LiveConnectionError.initialFetchError(error)
        }
            
        if (resp as! HTTPURLResponse).statusCode == 200,
           let html = String(data: data, encoding: .utf8) {
            return html
        } else {
            if let html = String(data: data, encoding: .utf8)
            {
                throw LiveConnectionError.initialFetchUnexpectedResponse(resp, html)
            } else {
                throw LiveConnectionError.initialFetchUnexpectedResponse(resp)
            }
        }
    }
    
    private func extractDOMValues(_ doc: SwiftSoup.Document) throws -> Void {
        let metaRes = try doc.select("meta[name=\"csrf-token\"]")
        guard !metaRes.isEmpty() else {
            throw LiveConnectionError.initialParseError(missingOrInvalid: .csrfToken)
        }
        self.phxCSRFToken = try metaRes[0].attr("content")
        self.liveReloadEnabled = !(try doc.select("iframe[src=\"/phoenix/live_reload/frame\"]").isEmpty())
        
        let mainDivRes = try doc.select("div[data-phx-main]")
        guard !mainDivRes.isEmpty() else {
            throw LiveConnectionError.initialParseError(missingOrInvalid: .phxMain)
        }
        let mainDiv = mainDivRes[0]
        self.phxSession = try mainDiv.attr("data-phx-session")
        self.phxStatic = try mainDiv.attr("data-phx-static")
        self.phxView = try mainDiv.attr("data-phx-view")
        self.phxID = try mainDiv.attr("id")
    }

    private func connectSocket() async throws {
        let cookies = HTTPCookieStorage.shared.cookies(for: self.url)
        
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
        var wsEndpoint = URLComponents(url: self.url, resolvingAgainstBaseURL: true)!
        wsEndpoint.scheme = self.url.scheme == "https" ? "wss" : "ws"
        wsEndpoint.path = "/live/websocket"
        let socket = Socket(endPoint: wsEndpoint.string!, transport: { [weak self] in _URLSessionTransport(url: $0, configuration: config, maximumMessageSize: self?.config.maximumMessageSize) }, paramsClosure: {["_csrf_token": self.phxCSRFToken]})
        self.socket = socket
        socket.onOpen { [weak self, weak socket] in
            guard let socket else { return }
            guard let self = self else {
                socket.disconnect()
                return
            }
            logger.debug("[Socket] Opened")
            if case .awaitingSocketConnection(let continuation) = self.internalState {
                continuation.resume()
            }
            DispatchQueue.main.async {
                self.internalState = .connected
            }
        }
        socket.onClose { logger.debug("[Socket] Closed") }
        socket.onError { [weak self, weak socket] (error) in
            guard let socket else { return }
            guard let self = self else {
                socket.disconnect()
                return
            }
            logger.error("[Socket] Error: \(String(describing: error))")
            if case .awaitingSocketConnection(let continuation) = self.internalState {
                continuation.resume(throwing: LiveConnectionError.socketError(error))
            } else {
                Task { @MainActor in
                    self.internalState = .connectionFailed(LiveConnectionError.socketError(error))
                }
            }
        }
        socket.logger = { message in logger.debug("[Socket] \(message)") }
        socket.connect()
    }
    
    private func connectLiveReloadSocket(urlSessionConfiguration: URLSessionConfiguration) async {
        logger.debug("[LiveReload] attempting to connect...")

        var liveReloadEndpoint = URLComponents(url: self.url, resolvingAgainstBaseURL: true)!
        liveReloadEndpoint.scheme = self.url.scheme == "https" ? "wss" : "ws"
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
    
    func redirect(_ redirect: LiveRedirect) async {
        switch redirect.mode {
        case .replaceTop:
            let coordinator = (navigationPath.last?.coordinator ?? rootCoordinator)!
            coordinator.url = redirect.to
            let entry = LiveNavigationEntry(url: redirect.to, coordinator: coordinator)
            switch redirect.kind {
            case .push:
                navigationPath.append(entry)
            case .replace:
                // If there is nothing to replace, change the root URL.
                if navigationPath.isEmpty {
                    rootCoordinator.url = redirect.to
                    await rootCoordinator.reconnect()
                } else {
                    navigationPath.removeLast()
                    navigationPath.append(entry)
                }
            }
        case .multiplex:
            switch redirect.kind {
            case .push:
                navigationPath.append(.init(
                    url: redirect.to,
                    coordinator: LiveViewCoordinator(session: self, url: redirect.to)
                ))
            case .replace:
                // If there is nothing to replace, change the root URL.
                if navigationPath.isEmpty {
                    rootCoordinator.url = redirect.to
                    await rootCoordinator.reconnect()
                } else {
                    navigationPath.removeLast()
                    // If we are replacing the current path with the previous one, just pop the URL so the previous one is on top.
                    guard (navigationPath.last?.coordinator.url ?? self.url) != redirect.to else { return }
                    navigationPath.append(.init(
                        url: redirect.to,
                        coordinator: LiveViewCoordinator(session: self, url: redirect.to)
                    ))
                }
            }
        }
    }
}

extension LiveSessionCoordinator {
    // The internal state enum stores more details associated with particular states but that we don't want publicly exposed.
    enum InternalState {
        case notConnected(reconnectAutomatically: Bool)
        case startingConnection
        case awaitingSocketConnection(CheckedContinuation<Void, Swift.Error>)
        case awaitingJoinResponse(CheckedContinuation<Payload, Swift.Error>)
        case connected
        case connectionFailed(Error)
        
        var publicState: LiveSessionState {
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
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public class _URLSessionTransport: NSObject, PhoenixTransport, URLSessionWebSocketDelegate {
    
    
    /// The URL to connect to
    internal let url: URL
    
    /// The URLSession configuratio
    internal let configuration: URLSessionConfiguration
    
    /// The underling URLsession. Assigned during `connect()`
    private var session: URLSession? = nil
    
    /// The ongoing task. Assigned during `connect()`
    private var task: URLSessionWebSocketTask? = nil
    
    private let maximumMessageSize: Int?
    
    
    /**
     Initializes a `Transport` layer built using URLSession's WebSocket
     
     Example:
     
     ```swift
     let url = URL("wss://example.com/socket")
     let transport: Transport = URLSessionTransport(url: url)
     ```
     
     Using a custom `URLSessionConfiguration`
     
     ```swift
     let url = URL("wss://example.com/socket")
     let configuration = URLSessionConfiguration.default
     let transport: Transport = URLSessionTransport(url: url, configuration: configuration)
     ```
     
     - parameter url: URL to connect to
     - parameter configuration: Provide your own URLSessionConfiguration. Uses `.default` if none provided
     */
    public init(url: URL, configuration: URLSessionConfiguration = .default, maximumMessageSize: Int?) {
        
        // URLSession requires that the endpoint be "wss" instead of "https".
        let endpoint = url.absoluteString
        let wsEndpoint = endpoint
            .replacingOccurrences(of: "http://", with: "ws://")
            .replacingOccurrences(of: "https://", with: "wss://")
        
        // Force unwrapping should be safe here since a valid URL came in and we just
        // replaced the protocol.
        self.url = URL(string: wsEndpoint)!
        self.configuration = configuration
        
        self.maximumMessageSize = maximumMessageSize
        
        super.init()
    }
    
    
    
    // MARK: - Transport
    public var readyState: PhoenixTransportReadyState = .closed
    public var delegate: PhoenixTransportDelegate? = nil
    
    public func connect() {
        // Set the trasport state as connecting
        self.readyState = .connecting
        
        // Create the session and websocket task
        self.session = URLSession(configuration: self.configuration, delegate: self, delegateQueue: OperationQueue())
        self.task = self.session?.webSocketTask(with: url)
        if let maximumMessageSize {
            self.task?.maximumMessageSize = maximumMessageSize
        }
        
        // Start the task
        self.task?.resume()
    }
    
    public func disconnect(code: Int, reason: String?) {
        /*
         TODO:
         1. Provide a "strict" mode that fails if an invalid close code is given
         2. If strict mode is disabled, default to CloseCode.invalid
         3. Provide default .normalClosure function
         */
        guard let closeCode = URLSessionWebSocketTask.CloseCode.init(rawValue: code) else {
            fatalError("Could not create a CloseCode with invalid code: [\(code)].")
        }
        
        self.readyState = .closing
        self.task?.cancel(with: closeCode, reason: reason?.data(using: .utf8))
    }
    
    public func send(data: Data) {
        self.task?.send(.string(String(data: data, encoding: .utf8)!)) { (error) in
            // TODO: What is the behavior when an error occurs?
        }
    }
    
    
    // MARK: - URLSessionWebSocketDelegate
    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didOpenWithProtocol protocol: String?) {
        // The Websocket is connected. Set Transport state to open and inform delegate
        self.readyState = .open
        self.delegate?.onOpen()
        
        // Start receiving messages
        self.receive()
    }
    
    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                           reason: Data?) {
        // A close frame was received from the server.
        self.readyState = .closed
        self.delegate?.onClose(code: closeCode.rawValue)
    }
    
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           didCompleteWithError error: Error?) {
        // The task has terminated. Inform the delegate that the transport has closed abnormally
        // if this was caused by an error.
        guard let err = error else { return }
        self.abnormalErrorReceived(err)
    }
    
    
    // MARK: - Private
    private func receive() {
        self.task?.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .data:
                    print("Data received. This method is unsupported by the Client")
                case .string(let text):
                    self.delegate?.onMessage(message: text)
                default:
                    fatalError("Unknown result was received. [\(result)]")
                }
                
                // Since `.receive()` is only good for a single message, it must
                // be called again after a message is received in order to
                // received the next message.
                self.receive()
            case .failure(let error):
                print("Error when receiving \(error)")
                self.abnormalErrorReceived(error)
            }
        }
    }
    
    private func abnormalErrorReceived(_ error: Error) {
        // Set the state of the Transport to closed
        self.readyState = .closed
        
        // Inform the Transport's delegate that an error occurred.
        self.delegate?.onError(error: error)
        
        // An abnormal error is results in an abnormal closure, such as internet getting dropped
        // so inform the delegate that the Transport has closed abnormally. This will kick off
        // the reconnect logic.
        self.delegate?.onClose(code: Socket.CloseCode.abnormal.rawValue)
    }
}
