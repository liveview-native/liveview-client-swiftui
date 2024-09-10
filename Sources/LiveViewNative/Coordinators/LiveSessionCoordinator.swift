//
//  LiveSessionCoordinator.swift
// LiveViewNative
//
//  Created by Brian Cardarella on 4/12/21.
//

import Foundation
import SwiftSoup
import SwiftUI
import Combine
import OSLog
import LiveViewNativeCore
import LiveViewNativeStylesheet

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
    /// The current state of the live view connection.
    @Published public private(set) var state = LiveSessionState.setup
    
    /// The current URL this live view is connected to.
    public private(set) var url: URL
    
    /// The current navigation path this live view is rendering.
    @Published public internal(set) var navigationPath = [LiveNavigationEntry<R>]()
    
    internal let configuration: LiveSessionConfiguration

    @Published private(set) var rootLayout: LiveViewNativeCore.Document?
    @Published private(set) var stylesheet: Stylesheet<R>?

    // Socket connection
    var liveSocket: LiveViewNativeCore.LiveSocket?
    var socket: LiveViewNativeCore.Socket?

    private var liveReloadSocket: LiveViewNativeCore.Socket?
    private var liveReloadChannel: LiveViewNativeCore.Channel?

    private var cancellables = Set<AnyCancellable>()

    private var mergedEventSubjects: AnyCancellable?
    private var eventSubject = PassthroughSubject<(LiveViewCoordinator<R>, (String, Payload)), Never>()
    private var eventHandlers = Set<AnyCancellable>()
    
    private var reconnectAttempts = 0
    
    /// Positions for `<ScrollView>` elements with an explicit ID.
    ///
    /// These positions are used for scroll restoration on back navigation.
    ///
    /// ``ScrollRestorationModifier`` gets and sets the values in this dictionary.
    ///
    /// The dictionary has the following structure:
    ///
    /// ```
    /// [<Route Index>: [<ScrollView ID>: <Scroll Offset>]]
    /// ```
    internal var scrollPositions: [Int:[String:AnyScrollPosition]] = [:]
    enum AnyScrollPosition {
        case id(String)
        case offset(CGPoint)
    }
    
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

        config.urlSessionConfiguration.httpCookieStorage = .shared
        
        self.navigationPath = [.init(url: url, coordinator: .init(session: self, url: self.url), navigationTransition: nil, pendingView: nil)]

        self.mergedEventSubjects = self.navigationPath.first!.coordinator.eventSubject.compactMap({ [weak self] value in
            self.map({ ($0.navigationPath.first!.coordinator, value) })
        })
        .sink(receiveValue: { [weak self] value in
            self?.eventSubject.send(value)
        })

        $navigationPath.scan(([LiveNavigationEntry<R>](), [LiveNavigationEntry<R>]()), { ($0.1, $1) }).sink { [weak self] prev, next in
            guard let self else { return }
            let isDisconnected = switch next.last!.coordinator.state {
            case .setup, .disconnected:
                true
            default:
                false
            }
            if next.last!.coordinator.url != next.last!.url || isDisconnected {
                Task {
                    if prev.count > next.count {
                        // back navigation
//                        try await next.last!.coordinator.connect(redirect: true)
                    } else if next.count > prev.count && prev.count > 0 {
                        // forward navigation (from `redirect` or `<NavigationLink>`)
//                        await prev.last?.coordinator.disconnect()
//                        try await next.last?.coordinator.connect(redirect: true)
                    }
                }
            }
        }.store(in: &cancellables)
        // Receive events from all live views.
        $navigationPath.sink { [weak self] entries in
            if let self {
                let allCoordinators = entries.map(\.coordinator)
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
    /// This function is a no-op unless ``state`` is ``LiveSessionState/setup`` or ``LiveSessionState/disconnected`` or ``LiveSessionState/connectionFailed(_:)``.
    ///
    /// This is an async function which completes when the connection has been established or failed.
    ///
    /// - Parameter httpMethod: The HTTP method to use for the dead render. Defaults to `GET`.
    /// - Parameter httpBody: The HTTP body to send when requesting the dead render.
    public func connect(httpMethod: String? = nil, httpBody: Data? = nil) async {
        switch state {
        case .setup, .disconnected, .connectionFailed:
            break
        default:
            return
        }

        let originalURL = self.navigationPath.last!.url

        logger.debug("Connecting to \(originalURL.absoluteString)")

        state = .connecting

        do {
            var request = URLRequest(url: originalURL)
            request.httpMethod = httpMethod
            request.httpBody = httpBody
            let (html, response) = try await deadRender(for: request, domValues: self.domValues)
            
            // update the URL if redirects happened.
            let url: URL
            if let responseURL = response.url {
                if self.navigationPath.count == 1 {
                    self.url = responseURL
                }
                self.navigationPath.last!.coordinator.url = responseURL
                self.navigationPath[self.navigationPath.endIndex - 1] = .init(
                    url: responseURL,
                    coordinator: self.navigationPath.last!.coordinator,
                    navigationTransition: nil,
                    pendingView: nil
                )
                url = responseURL
            } else {
                url = originalURL
            }

            let doc = try SwiftSoup.parse(html, url.absoluteString, SwiftSoup.Parser.xmlParser().settings(.init(true, true)))
            self.domValues = try self.extractDOMValues(doc)
            
            // extract the root layout, removing anything within the `<div data-phx-main>`.
            let mainDiv = try doc.select("div[data-phx-main]")[0]
            try mainDiv.replaceWith(doc.createElement("phx-main"))
            
            self.rootLayout = try LiveViewNativeCore.Document.parse(doc.outerHtml())

            let styleURLs = try doc.select("Style").compactMap {
                URL(string: try $0.attr("url"), relativeTo: url)
            }
            async let stylesheet = withThrowingTaskGroup(of: Stylesheet<R>.self) { group in
                for url in styleURLs {
                    group.addTask {
                        if let cachedStylesheet = await StylesheetCache.shared.read(for: url, registry: R.self) {
                            return cachedStylesheet
                        } else {
                            let (data, response) = try await self.urlSession.data(from: url)
                            if let response = response as? HTTPURLResponse,
                               !(200...299).contains(response.statusCode) {
                                throw AnyLocalizedError(errorDescription: "Downloading stylesheet '\(url.absoluteString)' failed with status code \(response.statusCode)")
                            }
                            guard let contents = String(data: data, encoding: .utf8)
                            else { return await Stylesheet<R>(content: [], classes: [:]) }
                            let stylesheet = try await Stylesheet<R>(from: contents, in: .init())
                            await StylesheetCache.shared.write(stylesheet, for: url, registry: R.self)
                            return stylesheet
                        }
                    }
                }
                return try await group.reduce(Stylesheet<R>(content: [], classes: [:])) { result, next in
                    return await result.merge(with: next)
                }
            }
            
            if socket == nil {
                try await self.connectSocket(domValues)
            }

            self.stylesheet = try await stylesheet

            try await navigationPath.last!.coordinator.connect(domValues: domValues, redirect: false)
            
            reconnectAttempts = 0
        } catch {
            self.state = .connectionFailed(error)
            logger.log(level: .error, "\(error.localizedDescription)")
            if let delay = configuration.reconnectBehavior.delay?(reconnectAttempts) {
                logger.log(level: .debug, "Reconnecting in \(delay) seconds")
                Task { [weak self] in
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    guard let self,
                          case .connectionFailed = self.state
                    else { return } // already connected
                    reconnectAttempts += 1
                    await self.connect(httpMethod: httpMethod, httpBody: httpBody)
                }
            }
            return
        }
    }

    private func disconnect(preserveNavigationPath: Bool = false) async {
        // disconnect all views
        for entry in navigationPath {
            await entry.coordinator.disconnect()
        }
        // reset all documents if navigation path is being reset.
        if !preserveNavigationPath {
            for entry in self.navigationPath {
                entry.coordinator.document = nil
            }
            
            self.navigationPath = [self.navigationPath.first!]
        }
        try! await self.socket?.disconnect()
        self.socket = nil
        self.state = .disconnected
    }

    /// Forces the session to disconnect then connect.
    ///
    /// All state will be lost when the reload occurs, as an entirely new LiveView is mounted.
    ///
    /// This can be used to force the LiveView to reset, for example after an unrecoverable error occurs.
    public func reconnect(url: URL? = nil, httpMethod: String? = nil, httpBody: Data? = nil) async {
        if let url {
            await self.disconnect(preserveNavigationPath: false)
            self.url = url
            self.navigationPath = [.init(url: self.url, coordinator: self.navigationPath.first!.coordinator, navigationTransition: nil, pendingView: nil)]
        } else {
            await self.disconnect(preserveNavigationPath: true)
        }
        await self.connect(httpMethod: httpMethod, httpBody: httpBody)
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

    /// Request the dead render with the given `request`.
    ///
    /// Returns the dead render HTML and the HTTP response information (including the final URL after redirects).
    func deadRender(
        for request: URLRequest,
        domValues: DOMValues?
    ) async throws -> (String, HTTPURLResponse) {
        
        var request = request
        request.url = request.url!.appendingLiveViewItems()
        request.allHTTPHeaderFields = configuration.headers
        
        if let domValues {
            request.setValue(domValues.phxCSRFToken, forHTTPHeaderField: "x-csrf-token")
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await urlSession.data(for: request)
        } catch {
            throw LiveConnectionError.initialFetchError(error)
        }

        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200,
              let html = String(data: data, encoding: .utf8)
        else {
            if let html = String(data: data, encoding: .utf8)
            {
                if try extractLiveReloadFrame(SwiftSoup.parse(html)) {
                    await connectLiveReloadSocket(urlSessionConfiguration: urlSession.configuration)
                }
                throw LiveConnectionError.initialFetchUnexpectedResponse(response, html)
            } else {
                throw LiveConnectionError.initialFetchUnexpectedResponse(response)
            }
        }
        return (html, response)
    }

    struct DOMValues {
        let phxCSRFToken: String
        let phxSession: String
        let phxStatic: String
        let phxView: String
        let phxID: String
        let liveReloadEnabled: Bool
    }
    
    nonisolated private func extractLiveReloadFrame(_ doc: SwiftSoup.Document) throws -> Bool {
        !(try doc.select("iframe[src=\"/phoenix/live_reload/frame\"]").isEmpty())
    }

    private func extractDOMValues(_ doc: SwiftSoup.Document) throws -> DOMValues {
        let csrfToken = try doc.select("csrf-token")
        guard !csrfToken.isEmpty() else {
            throw LiveConnectionError.initialParseError(missingOrInvalid: .csrfToken)
        }

        let mainDivRes = try doc.select("div[data-phx-main]")
        guard !mainDivRes.isEmpty() else {
            throw LiveConnectionError.initialParseError(missingOrInvalid: .phxMain)
        }
        let mainDiv = mainDivRes[0]
        return .init(
            phxCSRFToken: try csrfToken[0].attr("value"),
            phxSession: try mainDiv.attr("data-phx-session"),
            phxStatic: try mainDiv.attr("data-phx-static"),
            phxView: try mainDiv.attr("data-phx-view"),
            phxID: try mainDiv.attr("id"),
            liveReloadEnabled: try extractLiveReloadFrame(doc)
        )
    }

    @MainActor
    private func connectSocket(_ domValues: DOMValues) async throws {
        var wsEndpoint = await URLComponents(url: self.url, resolvingAgainstBaseURL: true)!
        wsEndpoint.scheme = await self.url.scheme == "https" ? "wss" : "ws"
        wsEndpoint.path = "/live/websocket"
        let configuration = await self.urlSession.configuration
        let socket = Socket(
            endPoint: wsEndpoint.string!,
            transport: {
                URLSessionTransport(url: $0, configuration: configuration)
            },
            paramsClosure: {
                [
                    "_csrf_token": domValues.phxCSRFToken,
                    "_format": "swiftui"
                ]
            }
        )
        
        socket.onClose { @Sendable in logger.debug("[Socket] Closed") }
        socket.logger = { @Sendable message in logger.debug("[Socket] \(message)") }
        
        try await withCheckedThrowingContinuation { [weak self] (continuation: CheckedContinuation<Void, any Error>) in
            guard let self else {
                return continuation.resume(throwing: LiveConnectionError.sessionCoordinatorReleased)
            }
            
            // set to `reconnecting` when the socket asks for the delay duration.
            socket.reconnectAfter = { @Sendable [weak self] tries in
                Task { @MainActor [weak self] in
                    self?.state = .reconnecting
                }
                return Defaults.reconnectSteppedBackOff(tries)
            }
            socket.onOpen { [weak self] in
                Task { @MainActor [weak self] in
                    guard case .reconnecting = await self?.state else { return }
                    self?.state = .connected
                }
            }
            
            var refs = [String]()
            
            refs.append(socket.onOpen { [weak self, weak socket] in
                guard let socket else { return }
                guard self != nil else {
                    socket.disconnect()
                    return
                }
                logger.debug("[Socket] Opened")
                socket.off(refs)
                continuation.resume()
            })
            refs.append(socket.onError { [weak self, weak socket, refs] (error, response) in
                guard let socket else { return }
                guard self != nil else {
                    socket.disconnect()
                    return
                }
                logger.error("[Socket] Error: \(String(describing: error))")
                socket.off(refs)
            })
        }
        self.socket?.onClose { logger.debug("[Socket] Closed") }
        self.socket?.logger = { message in logger.debug("[Socket] \(message)") }

        self.state = .connected

        if domValues.liveReloadEnabled {
            await self.connectLiveReloadSocket(urlSessionConfiguration: urlSession.configuration)
        }
    }
    
    private nonisolated func connectLiveReloadSocket(urlSessionConfiguration: URLSessionConfiguration) async {
        await MainActor.run {
            if let liveReloadSocket = self.liveReloadSocket {
                liveReloadSocket.disconnect()
                self.liveReloadSocket = nil
            }

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
        self.liveReloadChannel!.on("assets_change") { [weak self] _ in
            logger.debug("[LiveReload] assets changed, reloading")
            Task {
                await StylesheetCache.shared.removeAll()
                // need to fully reconnect (rather than just re-join channel) because the elixir code reloader only triggers on http reqs
                await self?.reconnect()
            }
        }
    }
    
    func redirect(
        _ redirect: LiveRedirect,
        navigationTransition: Any? = nil,
        pendingView: (any View)? = nil
    ) async throws {
        switch redirect.mode {
        case .replaceTop:
            let coordinator = LiveViewCoordinator(session: self, url: redirect.to)
            let entry = LiveNavigationEntry(url: redirect.to, coordinator: coordinator, navigationTransition: navigationTransition, pendingView: pendingView)
            switch redirect.kind {
            case .push:
                navigationPath.append(entry)
            case .replace:
                if !navigationPath.isEmpty {
                    if navigationPath.count == 1 {
                        self.url = redirect.to
                    }
                    coordinator.document = navigationPath.last!.coordinator.document
//                    await navigationPath.last?.coordinator.disconnect()
                    navigationPath[navigationPath.count - 1] = entry
//                    try await coordinator.connect(domValues: self.domValues, redirect: true)
                }
            }
        case .patch:
            // patch is like `replaceTop`, but it does not disconnect.
            let coordinator = navigationPath.last!.coordinator
            coordinator.url = redirect.to
            let entry = LiveNavigationEntry(url: redirect.to, coordinator: coordinator, navigationTransition: navigationTransition, pendingView: pendingView)
            switch redirect.kind {
            case .push:
                navigationPath.append(entry)
            case .replace:
                if !navigationPath.isEmpty {
                    navigationPath[navigationPath.count - 1] = entry
                }
            }
        }
    }
}

@MainActor
enum LiveSessionParameters {
    static var platform: String { "swiftui" }
    static var platformParams: LiveViewNativeCore.Json {
        .object(object: [
            "app_version": .str(string: getAppVersion()),
            "app_build": .str(string: getAppBuild()),
            "bundle_id": .str(string: getBundleID()),
            "os": .str(string: getOSName()),
            "os_version": .str(string: getOSVersion()),
            "target": .str(string: getTarget()),
            "l10n": getLocalization(),
            "i18n": getInternationalization()
        ])
    }

    private static func getAppVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!

        return dictionary["CFBundleShortVersionString"] as! String
    }

    private static func getAppBuild() -> String {
        let dictionary = Bundle.main.infoDictionary!

        return dictionary["CFBundleVersion"] as! String
    }

    private static func getBundleID() -> String {
        let dictionary = Bundle.main.infoDictionary!

        return dictionary["CFBundleIdentifier"] as! String
    }

    private static func getOSName() -> String {
        #if os(macOS)
        return "macOS"
        #elseif os(tvOS)
        return "tvOS"
        #elseif os(watchOS)
        return "watchOS"
        #elseif os(visionOS)
        return "visionOS"
        #elseif os(iOS)
        return "iOS"
        #else
        return "unknown"
        #endif
    }

    private static func getOSVersion() -> String {
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

    private static func getTarget() -> String {
        #if os(watchOS)
        return "watchos"
        #elseif os(macOS)
        return "macos"
        #elseif os(visionOS)
        return "visionos"
        #elseif os(tvOS)
        return "tvos"
        #else
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "ios"
        case .pad:
            return "ipados"
        case .mac:
            return "maccatalyst"
        case .tv:
            return "tvos"
        case .vision:
            return "visionos"
        default:
            return "unknown"
        }
        #endif
    }
    
    private static func getLocalization() -> Json {
        .object(object: [
            "locale": .str(string: Locale.autoupdatingCurrent.identifier),
        ])
    }
    
    private static func getInternationalization() -> Json {
        .object(object: [
            "time_zone": .str(string: TimeZone.autoupdatingCurrent.identifier),
        ])
    }
    
    static var queryItems: [URLQueryItem] = {
        /// Create a nested structure of query items.
        ///
        /// `_root[key][nested_key]=value`
        func queryParameters(for object: [String:Any]) -> [(name: String, value: String?)] {
            object.reduce(into: [(name: String, value: String?)]()) { (result, pair) in
                if let value = pair.value as? String {
                    result.append((name: "[\(pair.key)]", value: value))
                } else if let nested = pair.value as? [String:Any] {
                    result.append(contentsOf: queryParameters(for: nested).map {
                        return (name: "[\(pair.key)]\($0.name)", value: $0.value)
                    })
                }
            }
        }
        
        return queryParameters(for: platformParams)
            .map { queryItem in
                URLQueryItem(name: "_interface\(queryItem.name)", value: queryItem.value)
            }
            + [.init(name: "_format", value: platform)]
    }()
}

fileprivate extension URL {
    @MainActor
    func appendingLiveViewItems() -> Self {
        var result = self
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let existingQueryItems = (components?.queryItems ?? []).reduce(into: Set<String>()) { $0.insert($1) }
        result.append(
            queryItems: LiveSessionParameters.queryItems
                .filter({ !existingQueryItems.contains($0.name) })
        )
        return result
    }
}

extension Socket: @unchecked Sendable {}
extension Channel: @unchecked Sendable {}
