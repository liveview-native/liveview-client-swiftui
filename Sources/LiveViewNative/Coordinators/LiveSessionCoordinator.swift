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

/// The live view coordinator object handles connecting to Phoenix LiveView on the backend, managing the websocket connection, and transmitting/handling events.
@MainActor
public class LiveSessionCoordinator<R: CustomRegistry>: ObservableObject {
    @Published internal private(set) var internalState: InternalState = .notConnected(reconnectAutomatically: false)
    /// The current state of the live view connection.
    public var state: State {
        internalState.publicState
    }
    
    /// The current URL this live view is connected to.
    public private(set) var url: URL
    @Published private(set) var document: LiveViewNativeCore.Document?
    
    @Published var navigationPath = [URL]()
    
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
    
    /// Creates a new coordinator with a custom registry.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter config: The configuration for this coordinator.
    /// - Parameter customRegistryType: The type of the registry of custom views this coordinator will use when building the SwiftUI view tree from the DOM. This can generally be inferred automatically.
    public init(_ url: URL, config: LiveSessionConfiguration = .init(), customRegistryType _: R.Type = R.self) {
        self.url = url.appending(path: "").absoluteURL
        self.config = config
    }
    
    /// Creates a new coordinator without a custom registry.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter config: The configuration for this coordinator.
    public convenience init(_ url: URL, config: LiveSessionConfiguration = .init()) where R == EmptyRegistry {
        self.init(url, config: config, customRegistryType: EmptyRegistry.self)
    }
    
    deinit {
        Task {
            await self.disconnect()
        }
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
        // in case we're reconnecting, reset the document so nothing gets stale elements
        document = nil
        
        let html: String
        do {
            html = try await fetchDOM()
        } catch let error as LiveConnectionError {
            internalState = .connectionFailed(error)
            return
        }
        
        try Task.checkCancellation()
        
        do {
            let doc = try SwiftSoup.parse(html)
            try self.extractDOMValues(doc)
        } catch {
            internalState = .connectionFailed(LiveConnectionError.initialParseError)
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
        // when deliberately disconnect, don't let pending connections continue
        internalState = .notConnected(reconnectAutomatically: false)
    }
    
    @_spi(NarwinChat)
    public func reconnect() async {
        disconnect()
        await connect()
    }
    
    private func fetchDOM() async throws -> String {
        let data: Data
        let resp: URLResponse
        do {
            (data, resp) = try await config.urlSession.data(from: self.url)
        } catch {
            throw LiveConnectionError.initialFetchError(error)
        }
            
        if (resp as! HTTPURLResponse).statusCode == 200,
           let html = String(data: data, encoding: .utf8) {
            return html
        } else {
            throw LiveConnectionError.initialFetchUnexpectedResponse(resp)
        }
    }
    
    private func extractDOMValues(_ doc: SwiftSoup.Document) throws -> Void {
        let metaRes = try doc.select("meta[name=\"csrf-token\"]")
        guard !metaRes.isEmpty() else {
            throw LiveConnectionError.initialParseError
        }
        self.phxCSRFToken = try metaRes[0].attr("content")
        self.liveReloadEnabled = !(try doc.select("iframe[src=\"/phoenix/live_reload/frame\"]").isEmpty())
        
        let mainDivRes = try doc.select("div[data-phx-main=\"true\"]")
        guard !mainDivRes.isEmpty() else {
            throw LiveConnectionError.initialParseError
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
            DispatchQueue.main.async {
                self.internalState = .connected
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
    
    func redirectReplace(with url: URL) async {
        self.url = url
        await self.reconnect()
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
