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
    @Published internal private(set) var internalState: LiveSessionState = .notConnected
    /// The current state of the live view connection.
    public var state: LiveSessionState {
        internalState
    }
    
    /// The current URL this live view is connected to.
    public private(set) var url: URL
    
    @Published var navigationPath = [LiveNavigationEntry<R>]()
    var rootCoordinator: LiveViewCoordinator<R>!
    
    internal let configuration: LiveSessionConfiguration
    
    // Socket connection
    var socket: Socket?
    
    private var domValues: DOMValues!
    
    private var liveReloadSocket: Socket?
    private var liveReloadChannel: Channel?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var mergedEventSubjects: AnyCancellable?
    private var eventSubject = PassthroughSubject<(LiveViewCoordinator<R>, (String, Payload)), Never>()
    private var eventHandlers = Set<AnyCancellable>()
    
    public convenience init(_ host: some LiveViewHost, config: LiveSessionConfiguration = .init(), customRegistryType: R.Type = R.self) {
        self.init(host.url, config: config, customRegistryType: customRegistryType)
    }
    
    /// Creates a new coordinator with a custom registry.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter config: The configuration for this coordinator.
    /// - Parameter customRegistryType: The type of the registry of custom views this coordinator will use when building the SwiftUI view tree from the DOM. This can generally be inferred automatically.
    public init(_ url: URL, config: LiveSessionConfiguration = .init(), customRegistryType _: R.Type = R.self) {
        self.url = url.appending(path: "").absoluteURL
        self.configuration = config
        self.rootCoordinator = .init(session: self, url: self.url)
        self.mergedEventSubjects = self.rootCoordinator.eventSubject.compactMap({
            [weak self] value in self.map({ ($0.rootCoordinator, value) })
        })
        .sink(receiveValue: { [weak self] value in
            self?.eventSubject.send(value)
        })
        $navigationPath.scan(([LiveNavigationEntry<R>](), [LiveNavigationEntry<R>]()), { ($0.1, $1) }).sink { [weak self] prev, next in
            guard let self else { return }
            if prev.count > next.count {
                let last = next.last ?? .init(url: self.url, coordinator: self.rootCoordinator)
                if last.coordinator.url != last.url {
                    last.coordinator.url = last.url
                    Task { @MainActor in
                        try await last.coordinator.connect(domValues: self.domValues, redirect: true)
                    }
                }
            }
        }.store(in: &cancellables)
        // Receive events from all live views.
        $navigationPath.sink { [weak self] entries in
            if let self {
                let allCoordinators = ([self.rootCoordinator] + entries.map(\.coordinator))
                    .reduce(into: [LiveViewCoordinator<R>]()) { result, next in
                        guard !result.contains(where: { $0 === next }) else { return }
                        result.append(next)
                    }
                self.mergedEventSubjects = Publishers.MergeMany(allCoordinators.map({ coordinator in
                    coordinator.eventSubject.map({ (coordinator, $0) })
                }))
                .sink(receiveValue: { [weak self] value in
                    self?.eventSubject.send(value)
                })
            }
        }.store(in: &cancellables)
        handleEvent("_native_persistence_store") { coordinator, payload in
            guard let value = payload["value"],
                  let key = payload["key"] as? String,
                  let options = payload["options"] as? [String:Any]
            else { return }
            try? config.persistenceStore.setValue(value, forKey: key, options: options)
        }
        handleEvent("_native_persistence_load") { coordinator, payload in
            guard let key = payload["key"] as? String,
                  let loadedEvent = payload["event"] as? String,
                  let options = payload["options"] as? [String:Any],
                  let value = try? config.persistenceStore.loadValue(forKey: key, options: options)
            else { return }
            Task {
                try await coordinator.pushEvent(type: "click", event: loadedEvent, value: value)
            }
        }
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
        guard case .notConnected = internalState else {
            return
        }
        
        logger.debug("Connecting to \(self.url.absoluteString)")
        
        internalState = .connecting
        
        let html: String
        do {
            html = try await fetchDOM(url: self.url)
        } catch {
            internalState = .connectionFailed(error)
            return
        }
        
        let domValues: DOMValues
        do {
            let doc = try SwiftSoup.parse(html)
            domValues = try self.extractDOMValues(doc)
        } catch {
            internalState = .connectionFailed(error)
            return
        }
        
        self.domValues = domValues
        
        if socket == nil {
            do {
                try await self.connectSocket(domValues)
            } catch {
                internalState = .connectionFailed(error)
                return
            }
        }
        
        do {
            try await rootCoordinator.connect(domValues: domValues, redirect: false)
        } catch {
            self.internalState = .connectionFailed(error)
        }
    }
    
    private func disconnect() async {
        await rootCoordinator.disconnect()
        for entry in self.navigationPath {
            await entry.coordinator.disconnect()
        }
        self.navigationPath.removeAll()
        self.socket?.disconnect()
        self.socket = nil
        self.internalState = .notConnected
    }
    
    /// Forces the session to disconnect then connect.
    ///
    /// All state will be lost when the reload occurs, as an entirely new LiveView is mounted.
    ///
    /// This can be used to force the LiveView to reset, for example after an unrecoverable error occurs.
    public func reconnect() async {
        await self.disconnect()
        await self.connect()
    }
    
    /// Creates a publisher that can be used to listen for server-sent LiveView events.
    ///
    /// - Parameter event: The event name that is being listened for.
    /// - Returns: A publisher that emits event payloads.
    ///
    /// This event will be received from every LiveView handled by this session coordinator.
    ///
    /// See ``LiveViewCoordinator/receiveEvent(_:)`` for more details.
    public func receiveEvent(_ event: String) -> some Publisher<(LiveViewCoordinator<R>, Payload), Never> {
        eventSubject
            .filter { $0.1.0 == event }
            .map({ ($0.0, $0.1.1) })
    }
    
    /// Permanently registers a handler for a server-sent LiveView event.
    ///
    /// - Parameter event: The event name that is being listened for.
    /// - Parameter handler: A closure to invoke when the coordinator receives an event. The event value is provided as the closure's parameter.
    ///
    /// This event handler will be added to every LiveView handled by this session coordinator.
    ///
    /// See ``LiveViewCoordinator/handleEvent(_:handler:)`` for more details.
    public func handleEvent(_ event: String, handler: @escaping (LiveViewCoordinator<R>, Payload) -> Void) {
        receiveEvent(event)
            .sink(receiveValue: handler)
            .store(in: &eventHandlers)
    }
    
    func fetchDOM(url: URL) async throws -> String {
        let data: Data
        let resp: URLResponse
        do {
            (data, resp) = try await configuration.urlSession.data(from: url.appending(queryItems: [
                .init(name: "_platform", value: platform)
            ]))
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
    
    struct DOMValues {
        let phxCSRFToken: String
        let phxSession: String
        let phxStatic: String
        let phxView: String
        let phxID: String
        let liveReloadEnabled: Bool
    }
    
    private func extractDOMValues(_ doc: SwiftSoup.Document) throws -> DOMValues {
        let metaRes = try doc.select("meta[name=\"csrf-token\"]")
        guard !metaRes.isEmpty() else {
            throw LiveConnectionError.initialParseError(missingOrInvalid: .csrfToken)
        }
        
        let mainDivRes = try doc.select("div[data-phx-main]")
        guard !mainDivRes.isEmpty() else {
            throw LiveConnectionError.initialParseError(missingOrInvalid: .phxMain)
        }
        let mainDiv = mainDivRes[0]
        return .init(
            phxCSRFToken: try metaRes[0].attr("content"),
            phxSession: try mainDiv.attr("data-phx-session"),
            phxStatic: try mainDiv.attr("data-phx-static"),
            phxView: try mainDiv.attr("data-phx-view"),
            phxID: try mainDiv.attr("id"),
            liveReloadEnabled: !(try doc.select("iframe[src=\"/phoenix/live_reload/frame\"]").isEmpty())
        )
    }

    private func connectSocket(_ domValues: DOMValues) async throws {
        let cookies = HTTPCookieStorage.shared.cookies(for: self.url)
        
        let configuration = configuration.urlSession.configuration
        for cookie in cookies! {
            configuration.httpCookieStorage!.setCookie(cookie)
        }
    
        self.socket = try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                return continuation.resume(throwing: LiveConnectionError.sessionCoordinatorReleased)
            }
            
            var wsEndpoint = URLComponents(url: self.url, resolvingAgainstBaseURL: true)!
            wsEndpoint.scheme = self.url.scheme == "https" ? "wss" : "ws"
            wsEndpoint.path = "/live/websocket"
            let socket = Socket(endPoint: wsEndpoint.string!, transport: { URLSessionTransport(url: $0, configuration: configuration) }, paramsClosure: {["_csrf_token": domValues.phxCSRFToken]})
            
            var refs = [String]()
            
            refs.append(socket.onOpen { [weak self, weak socket] in
                guard let socket else { return }
                guard self != nil else {
                    socket.disconnect()
                    return
                }
                logger.debug("[Socket] Opened")
                socket.off(refs)
                continuation.resume(returning: socket)
            })
            refs.append(socket.onError { [weak self, weak socket] (error) in
                guard let socket else { return }
                guard self != nil else {
                    socket.disconnect()
                    return
                }
                logger.error("[Socket] Error: \(String(describing: error))")
                socket.off(refs)
                continuation.resume(throwing: LiveConnectionError.socketError(error))
            })
            socket.connect()
        }
        self.socket?.onClose { logger.debug("[Socket] Closed") }
        self.socket?.logger = { message in logger.debug("[Socket] \(message)") }
        
        self.internalState = .connected
        
        if domValues.liveReloadEnabled {
            await self.connectLiveReloadSocket(urlSessionConfiguration: configuration)
        }
    }
    
    private func connectLiveReloadSocket(urlSessionConfiguration: URLSessionConfiguration) async {
        if let liveReloadSocket = self.liveReloadSocket {
            liveReloadSocket.disconnect()
            self.liveReloadSocket = nil
        }
        
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
    
    func redirect(_ redirect: LiveRedirect) async throws {
        switch redirect.mode {
        case .replaceTop:
            let coordinator = (navigationPath.last?.coordinator ?? rootCoordinator)!
            coordinator.url = redirect.to
            await coordinator.disconnect()
            let entry = LiveNavigationEntry(url: redirect.to, coordinator: coordinator)
            switch redirect.kind {
            case .push:
                navigationPath.append(entry)
            case .replace:
                // If there is nothing to replace, change the root URL.
                if !navigationPath.isEmpty {
                    navigationPath[navigationPath.count - 1] = entry
                }
            }
            try await coordinator.connect(domValues: self.domValues, redirect: true)
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
                    try await rootCoordinator.connect(domValues: self.domValues, redirect: true)
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
    var platform: String { "swiftui" }
    var platformMeta: Payload {
        [
            "os_name": getOSName(),
            "os_version": getOSVersion(),
            "user_interface_idiom": getUserInterfaceIdiom()
        ]
    }
    
    private func getOSName() -> String {
        #if os(macOS)
        return "macOS"
        #elseif os(tvOS)
        return "tvOS"
        #elseif os(watchOS)
        return "watchOS"
        #else
        return "iOS"
        #endif
    }

    private func getOSVersion() -> String {
        #if os(watchOS)
        return WKInterfaceDevice.current().systemVersion
        #elseif os(macOS)
        let operatingSystemVersion = ProcessInfo.processInfo.operatingSystemVersion
        let majorVersion = operatingSystemVersion.majorVersion
        let minorVersion = operatingSystemVersion.minorVersion
        let patchVersion = operatingSystemVersion.patchVersion
        
        return "\(majorVersion).\(minorVersion).\(patchVersion)"
        #else
        return UIDevice.current.systemVersion
        #endif
    }

    private func getUserInterfaceIdiom() -> String {
        #if os(watchOS)
        return "watch"
        #elseif os(macOS)
        return "mac"
        #else
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "phone"
        case .pad:
            return "pad"
        case .mac:
            return "mac"
        case .tv:
            return "tv"
        default:
            return "unspecified"
        }
        #endif
    }
}
