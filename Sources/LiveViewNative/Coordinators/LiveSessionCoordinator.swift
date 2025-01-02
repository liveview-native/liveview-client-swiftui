//
//  LiveSessionCoordinator.swift
// LiveViewNative
//
//  Created by Brian Cardarella on 4/12/21.
//

import Foundation
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

    private var liveReloadChannel: LiveViewNativeCore.LiveChannel?
    private var liveReloadListener: Channel.EventStream?
    private var liveReloadListenerLoop: Task<(), any Error>?
    
    private var cancellables = Set<AnyCancellable>()

    private var mergedEventSubjects: AnyCancellable?
    private var eventSubject = PassthroughSubject<(LiveViewCoordinator<R>, (String, Json)), Never>()
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
        
        // load cookies into core
        for cookie in HTTPCookieStorage.shared.cookies(for: url) ?? [] {
            try? LiveViewNativeCore.storeSessionCookie("\(cookie.name)=\(cookie.value)", self.url.absoluteString)
        }
        
        self.navigationPath = [.init(url: url, coordinator: .init(session: self, url: self.url), navigationTransition: nil, pendingView: nil)]

        self.mergedEventSubjects = self.navigationPath.first!.coordinator.eventSubject.compactMap({ [weak self] value in
            self.map({ ($0.navigationPath.first!.coordinator, value) })
        })
        .sink(receiveValue: { [weak self] value in
            self?.eventSubject.send(value)
        })

        $navigationPath.scan(([LiveNavigationEntry<R>](), [LiveNavigationEntry<R>]()), { ($0.1, $1) }).sink { [weak self] prev, next in
            guard let self else { return }
            Task {
                try await prev.last?.coordinator.disconnect()
                if prev.count > next.count {
                    // back navigation (we could be going back multiple pages at once, so use `traverseTo` instead of `back`)
                    let targetEntry = self.liveSocket!.getEntries()[next.count - 1]
                    next.last?.coordinator.join(
                        try await self.liveSocket!.traverseTo(targetEntry.id, next.last!.coordinator.liveChannel, nil)
                    )
                } else if next.count > prev.count && prev.count > 0 {
                    // forward navigation (from `redirect` or `<NavigationLink>`)
                    next.last?.coordinator.join(
                        try await self.liveSocket!.navigate(next.last!.url.absoluteString, next.last!.coordinator.liveChannel, NavOptions(action: .push))
                    )
                } else if next.count == prev.count {
                    guard let liveChannel = try await self.liveSocket?.navigate(next.last!.url.absoluteString, next.last!.coordinator.liveChannel, NavOptions(action: .replace))
                    else { return }
                    next.last?.coordinator.join(liveChannel)
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
    
    deinit {
        self.liveReloadListenerLoop?.cancel()
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
    public func connect(httpMethod: String? = nil, httpBody: Data? = nil, additionalHeaders: [String: String]? = nil) async {
        do {
            switch state {
            case .setup, .disconnected, .connectionFailed:
                break
            default:
                return
            }
            
            let originalURL = self.navigationPath.last!.url
            
            logger.debug("Connecting to \(originalURL.absoluteString)")
            
            state = .connecting
            
            let headers = (configuration.headers ?? [:])
                .merging(additionalHeaders ?? [:]) { $1 }
            
            self.liveSocket = try await LiveSocket(
                originalURL.absoluteString,
                LiveSessionParameters.platform,
                ConnectOpts(
                    headers: headers,
                    body: httpBody.flatMap({ String(data: $0, encoding: .utf8) }),
                    method: httpMethod.flatMap(Method.init(_:)),
                    timeoutMs: 10_000
                )
            )
            
            // save cookies to storage
            HTTPCookieStorage.shared.setCookies(
                (self.liveSocket!.joinHeaders()["set-cookie"] ?? []).flatMap {
                    HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie": $0], for: URL(string: self.liveSocket!.joinUrl())!)
                },
                for: self.url,
                mainDocumentURL: nil
            )
            
            self.socket = self.liveSocket?.socket()
            
            self.rootLayout = self.liveSocket!.deadRender()
            let styleURLs = self.liveSocket!.styleUrls()
            
            self.stylesheet = try await withThrowingTaskGroup(of: Stylesheet<R>.self) { @Sendable group in
                for style in styleURLs {
                    guard let url = await URL(string: style, relativeTo: self.url)
                    else { continue }
                    group.addTask {
                        if let cached = await StylesheetCache.shared.read(for: url, registry: R.self) {
                            return cached
                        } else {
                            let (data, _) = try await URLSession.shared.data(from: url)
                            guard let contents = String(data: data, encoding: .utf8)
                            else { return await Stylesheet<R>(content: [], classes: [:]) }
                            return try await Stylesheet<R>(from: contents, in: .init())
                        }
                    }
                }
                
                return try await group.reduce(Stylesheet<R>(content: [], classes: [:])) { result, next in
                    return await result.merge(with: next)
                }
            }
            
            let liveChannel = try await self.liveSocket!.joinLiveviewChannel(
                .some([
                    "_format": .str(string: LiveSessionParameters.platform),
                    "_interface": .object(object: LiveSessionParameters.platformParams)
                ]),
                nil
            )
            
            self.navigationPath.last!.coordinator.join(liveChannel)
            
            self.state = .connected
            
            if self.liveSocket!.hasLiveReload() {
                self.liveReloadChannel = try await self.liveSocket!.joinLivereloadChannel()
                bindLiveReloadListener()
            }
        } catch {
            self.state = .connectionFailed(error)
        }
    }
    
    func bindLiveReloadListener() {
        let eventListener = self.liveReloadChannel!.channel().eventStream()
        self.liveReloadListener = eventListener
        self.liveReloadListenerLoop = Task { @MainActor [weak self] in
            for try await event in eventListener {
                guard let self else { return }
                switch event.event {
                case .user(user: "assets_change"):
                    try await self.disconnect()
                    self.navigationPath = [.init(url: self.url, coordinator: .init(session: self, url: self.url), navigationTransition: nil, pendingView: nil)]
                    try await self.connect()
                default:
                    continue
                }
            }
        }
    }

    private func disconnect(preserveNavigationPath: Bool = false) async {
        do {
            for entry in self.navigationPath {
                try await entry.coordinator.disconnect()
                if !preserveNavigationPath {
                    entry.coordinator.document = nil
                }
            }
            // reset all documents if navigation path is being reset.
            if !preserveNavigationPath {
                for entry in self.navigationPath {
                    entry.coordinator.document = nil
                }
                
                self.navigationPath = [self.navigationPath.first!]
            }
            try await self.liveReloadChannel?.channel().leave()
            self.liveReloadChannel = nil
            try await self.socket?.disconnect()
            self.socket = nil
            self.liveSocket = nil
            self.state = .disconnected
        } catch {
            self.state = .connectionFailed(error)
        }
    }

    /// Forces the session to disconnect then connect.
    ///
    /// All state will be lost when the reload occurs, as an entirely new LiveView is mounted.
    ///
    /// This can be used to force the LiveView to reset, for example after an unrecoverable error occurs.
    public func reconnect(url: URL? = nil, httpMethod: String? = nil, httpBody: Data? = nil, headers: [String: String]? = nil) async {
        await self.disconnect()
        if let url {
            self.url = url
            self.navigationPath = [.init(url: self.url, coordinator: self.navigationPath.first!.coordinator, navigationTransition: nil, pendingView: nil)]
        }
        try await self.connect(httpMethod: httpMethod, httpBody: httpBody, additionalHeaders: headers)
//        do {
//            if let url {
//                try await self.disconnect(preserveNavigationPath: false)
//                self.url = url
//                self.navigationPath = [.init(url: self.url, coordinator: self.navigationPath.first!.coordinator, navigationTransition: nil, pendingView: nil)]
//            } else {
//                // preserve the navigation path, but still clear the stale documents, since they're being completely replaced.
//                try await self.disconnect(preserveNavigationPath: true)
//                for entry in self.navigationPath {
//                    entry.coordinator.document = nil
//                }
//            }
//            try await self.connect(httpMethod: httpMethod, httpBody: httpBody, additionalHeaders: headers)
//        } catch {
//            self.state = .connectionFailed(error)
//        }
    }

    /// Creates a publisher that can be used to listen for server-sent LiveView events.
    ///
    /// - Parameter event: The event name that is being listened for.
    /// - Returns: A publisher that emits event payloads.
    ///
    /// This event will be received from every LiveView handled by this session coordinator.
    ///
    /// See ``LiveViewCoordinator/receiveEvent(_:)`` for more details.
    public func receiveEvent(_ event: String) -> some Publisher<(LiveViewCoordinator<R>, Json), Never> {
        eventSubject
            .filter { $0.1.0 == event }
            .map({ ($0.0, $0.1.1) })
    }
    
    public func receiveEvent<T>(_ event: String, for type: T.Type = T.self) -> some Publisher<(LiveViewCoordinator<R>, T), Never>
        where T: Decodable
    {
        eventSubject
            .filter { $0.1.0 == event }
            .tryMap({ ($0.0, try JsonDecoder().decode(T.self, from: $0.1.1)) })
            .catch({ _ in Empty() })
    }

    /// Permanently registers a handler for a server-sent LiveView event.
    ///
    /// - Parameter event: The event name that is being listened for.
    /// - Parameter handler: A closure to invoke when the coordinator receives an event. The event value is provided as the closure's parameter.
    ///
    /// This event handler will be added to every LiveView handled by this session coordinator.
    ///
    /// See ``LiveViewCoordinator/handleEvent(_:handler:)`` for more details.
    public func handleEvent(_ event: String, handler: @escaping (LiveViewCoordinator<R>, Json) -> Void) {
        receiveEvent(event)
            .sink(receiveValue: handler)
            .store(in: &eventHandlers)
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
    static var platformParams: [String:LiveViewNativeCore.Json] {
        [
            "app_version": .str(string: getAppVersion()),
            "app_build": .str(string: getAppBuild()),
            "bundle_id": .str(string: getBundleID()),
            "os": .str(string: getOSName()),
            "os_version": .str(string: getOSVersion()),
            "target": .str(string: getTarget()),
            "l10n": getLocalization(),
            "i18n": getInternationalization()
        ]
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
        func queryParameters(for object: [String:Json]) -> [(name: String, value: String?)] {
            object.reduce(into: [(name: String, value: String?)]()) { (result, pair) in
                if let value = pair.value as? String {
                    result.append((name: "[\(pair.key)]", value: value))
                } else if case let .object(nested) = pair.value {
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
