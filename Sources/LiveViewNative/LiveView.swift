//
//  LiveView.swift
//  LiveViewTest
//
//  Created by Brian Cardarella on 4/28/21.
//

import Foundation
import SwiftUI
import Combine

/// Create a ``LiveView`` with a list of addons.
///
/// Use this macro to automatically register any addons.
/// Use a placeholder type (`_`) as the root for each registry.
///
/// ```swift
/// #LiveView(.localhost, addons: [ChartsRegistry<_>.self, AVKitRegistry<_>.self])
/// ```
///
/// - Note: This macro erases the underlying ``LiveView`` to `AnyView`.
/// This may incur a minor performance hit when updating the `View` containing the ``LiveView``.
@freestanding(expression)
public macro LiveView<
    Host: LiveViewHost,
    ConnectingView: View,
    DisconnectedView: View,
    ReconnectingView: View,
    ErrorView: View
>(
    _ host: Host,
    configuration: LiveSessionConfiguration = .init(),
    addons: [any CustomRegistry<EmptyRegistry>.Type] = [],
    @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
    @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
    @ViewBuilder reconnecting: @escaping (AnyView, Bool) -> ReconnectingView = { (_: AnyView, _: Bool) -> Never in fatalError() },
    @ViewBuilder error: @escaping (Error) -> ErrorView = { (_: Error) -> Never in fatalError() }
) -> AnyView = #externalMacro(module: "LiveViewNativeMacros", type: "LiveViewMacro")

public struct _StatelessReconnectingView<Content: View>: View {
    let content: AnyView
    let isReconnecting: Bool
    let reconnectingView: (AnyView) -> Content
    
    public var body: some View {
        if isReconnecting {
            reconnectingView(content)
        } else {
            content
        }
    }
}

/// The SwiftUI root view for a Phoenix LiveView.
///
/// The `LiveView` attempts to connect immediately when it appears.
///
/// While in states other than ``LiveSessionState/connected``, this view only provides a basic text description of the state.
///
/// ## Topics
/// ### Creating a LiveView
/// - ``init(session:)``
/// ### Supporting Types
/// - ``body``
/// ### See Also
/// - ``LiveViewModel``
public struct LiveView<
    R: RootRegistry,
    ConnectingView: View,
    DisconnectedView: View,
    ReconnectingView: View,
    ErrorView: View
>: View {
    @StateObject var session: LiveSessionCoordinator<R>
    
    @StateObject private var liveViewModel = LiveViewModel()
    
    @Environment(\.scenePhase) private var scenePhase
    
    let connectingView: () -> ConnectingView
    let disconnectedView: () -> DisconnectedView
    let reconnectingView: (AnyView, Bool) -> ReconnectingView
    let errorView: (Error) -> ErrorView
    
    /// Creates a new LiveView attached to the given coordinator.
    ///
    /// - Note: Changing coordinators after the `LiveView` is setup and connected is forbidden.
    public init(
        registry _: R.Type = EmptyRegistry.self,
        session: @autoclosure @escaping () -> LiveSessionCoordinator<R>,
        @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
        @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
        @ViewBuilder reconnecting: @escaping (AnyView, Bool) -> ReconnectingView = { (_: AnyView, _: Bool) -> Never in fatalError() },
        @ViewBuilder error: @escaping (Error) -> ErrorView = { (_: Error) -> Never in fatalError() }
    ) {
        self._session = .init(wrappedValue: session())
        self.connectingView = connecting
        self.disconnectedView = disconnected
        self.reconnectingView = reconnecting
        self.errorView = error
    }
    
    public init(
        registry: R.Type = EmptyRegistry.self,
        _ host: some LiveViewHost,
        configuration: LiveSessionConfiguration = .init(),
        @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
        @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
        @ViewBuilder reconnecting: @escaping (AnyView, Bool) -> ReconnectingView = { (_: AnyView, _: Bool) -> Never in fatalError() },
        @ViewBuilder error: @escaping (Error) -> ErrorView = { (_: Error) -> Never in fatalError() }
    ) {
        self.init(
            registry: registry,
            session: .init(host.url, config: configuration),
            connecting: connecting,
            disconnected: disconnected,
            reconnecting: reconnecting,
            error: error
        )
    }
    
    public init(
        registry: R.Type = EmptyRegistry.self,
        url: URL,
        configuration: LiveSessionConfiguration = .init(),
        @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
        @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
        @ViewBuilder reconnecting: @escaping (AnyView, Bool) -> ReconnectingView = { (_: AnyView, _: Bool) -> Never in fatalError() },
        @ViewBuilder error: @escaping (Error) -> ErrorView = { (_: Error) -> Never in fatalError() }
    ) {
        self.init(
            registry: registry,
            session: .init(url, config: configuration),
            connecting: connecting,
            disconnected: disconnected,
            reconnecting: reconnecting,
            error: error
        )
    }
    
    public init<ReconnectingContent>(
        registry: R.Type = EmptyRegistry.self,
        session: @autoclosure @escaping () -> LiveSessionCoordinator<R>,
        @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
        @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
        @ViewBuilder reconnecting: @escaping (AnyView) -> ReconnectingContent,
        @ViewBuilder error: @escaping (Error) -> ErrorView = { (_: Error) -> Never in fatalError() }
    ) where ReconnectingView == _StatelessReconnectingView<ReconnectingContent>, ReconnectingContent: View {
        self.init(
            registry: registry,
            session: session(),
            connecting: connecting,
            disconnected: disconnected,
            reconnecting: { content, isReconnecting in
                _StatelessReconnectingView<ReconnectingContent>(content: content, isReconnecting: isReconnecting, reconnectingView: reconnecting)
            },
            error: error
        )
    }
    
    public init<ReconnectingContent>(
        registry: R.Type = EmptyRegistry.self,
        _ host: some LiveViewHost,
        configuration: LiveSessionConfiguration = .init(),
        @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
        @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
        @ViewBuilder reconnecting: @escaping (AnyView) -> ReconnectingContent,
        @ViewBuilder error: @escaping (Error) -> ErrorView = { (_: Error) -> Never in fatalError() }
    ) where ReconnectingView == _StatelessReconnectingView<ReconnectingContent>, ReconnectingContent: View {
        self.init(
            registry: registry,
            session: .init(host.url, config: configuration),
            connecting: connecting,
            disconnected: disconnected,
            reconnecting: reconnecting,
            error: error
        )
    }
    
    public init<ReconnectingContent>(
        registry: R.Type = EmptyRegistry.self,
        url: URL,
        configuration: LiveSessionConfiguration = .init(),
        @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
        @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
        @ViewBuilder reconnecting: @escaping (AnyView) -> ReconnectingContent,
        @ViewBuilder error: @escaping (Error) -> ErrorView = { (_: Error) -> Never in fatalError() }
    ) where ReconnectingView == _StatelessReconnectingView<ReconnectingContent>, ReconnectingContent: View {
        self.init(
            registry: registry,
            session: .init(url, config: configuration),
            connecting: connecting,
            disconnected: disconnected,
            reconnecting: reconnecting,
            error: error
        )
    }
    
    private var rootCoordinator: LiveViewCoordinator<R> {
        session.navigationPath.first!.coordinator
    }
    
    public var body: some View {
        SwiftUI.Group {
            switch session.state {
            case .connected, .reconnecting:
                if ReconnectingView.self == Never.self {
                    SwiftUI.Group {
                        if let rootLayout = session.rootLayout {
                            self.rootCoordinator.builder.fromNodes(rootLayout[rootLayout.root()].children(), coordinator: rootCoordinator, url: rootCoordinator.url)
                                .environment(\.coordinatorEnvironment, CoordinatorEnvironment(rootCoordinator, document: rootLayout))
                        } else {
                            PhxMain<R>()
                                .environment(\.coordinatorEnvironment, CoordinatorEnvironment(rootCoordinator, document: rootCoordinator.document!))
                                .environment(\.anyLiveContextStorage, LiveContextStorage(coordinator: rootCoordinator, url: rootCoordinator.url))
                        }
                    }
                        .safeAreaInset(edge: .top) {
                            if session.state.isReconnecting {
                                SwiftUI.VStack {
                                    SwiftUI.Label("No Connection", systemImage: "wifi.slash")
                                        .bold()
                                    SwiftUI.Text("Reconnecting")
                                        .foregroundStyle(.secondary)
                                        .tint(.secondary)
                                }
                                    .font(.caption)
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(.regularMaterial)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .animation(.default, value: session.state.isReconnecting)
                } else {
                    reconnectingView(
                        AnyView(
                            SwiftUI.Group {
                                if let rootLayout = session.rootLayout {
                                    self.rootCoordinator.builder.fromNodes(rootLayout[rootLayout.root()].children(), coordinator: rootCoordinator, url: rootCoordinator.url)
                                        .environment(\.coordinatorEnvironment, CoordinatorEnvironment(rootCoordinator, document: rootLayout))
                                } else {
                                    PhxMain<R>()
                                        .environment(\.coordinatorEnvironment, CoordinatorEnvironment(rootCoordinator, document: rootCoordinator.document!))
                                        .environment(\.anyLiveContextStorage, LiveContextStorage(coordinator: rootCoordinator, url: rootCoordinator.url))
                                }
                            }
                        ),
                        session.state.isReconnecting
                    )
                }
            default:
                switch session.state {
                case .connected, .reconnecting:
                    fatalError()
                case .notConnected:
                    if DisconnectedView.self == Never.self {
                        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                            SwiftUI.ContentUnavailableView {
                                SwiftUI.Label("No Connection", systemImage: "network.slash")
                            } description: {
                                SwiftUI.Text("The app will reconnect when network connection is regained.")
                            }
                        } else {
                            SwiftUI.Text("No Connection")
                        }
                    } else {
                        disconnectedView()
                    }
                case .connecting:
                    if ConnectingView.self == Never.self {
                        SwiftUI.ProgressView("Connecting")
                    } else {
                        connectingView()
                    }
                case .connectionFailed(let error):
                    if ErrorView.self == Never.self {
                        if let error = error as? LiveConnectionError,
                           case let .initialFetchUnexpectedResponse(_, trace?) = error
                        {
                            AnyErrorView<R>(html: trace)
                        } else {
                            if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                                SwiftUI.ContentUnavailableView {
                                    SwiftUI.Label("No Connection", systemImage: "network.slash")
                                } description: {
                                    #if DEBUG
                                    SwiftUI.Text(error.localizedDescription)
                                        .monospaced()
                                    #else
                                    SwiftUI.Text("The app will reconnect when network connection is regained.")
                                    #endif
                                }
                            } else {
                                SwiftUI.VStack {
                                    SwiftUI.Text("No Connection")
                                        .font(.subheadline)
                                    SwiftUI.Text(error.localizedDescription)
                                }
                            }
                        }
                    } else {
                        errorView(error)
                    }
                }
            }
        }
        .transformEnvironment(\.stylesheets) { stylesheets in
            guard let stylesheet = session.stylesheet
            else { return }
            stylesheets[ObjectIdentifier(R.self)] = stylesheet
        }
        .environmentObject(session)
        .environmentObject(liveViewModel)
        .task {
            await session.connect()
        }
        .onChange(of: scenePhase) { newValue in
            guard case .active = newValue,
                  session.socket?.isConnected == false
            else { return }
            Task {
                await session.connect()
            }
        }
    }
}

struct PhxMain<R: RootRegistry>: View {
    @LiveContext<R> private var context
    @EnvironmentObject private var session: LiveSessionCoordinator<R>
    
    var body: some View {
        NavStackEntryView(.init(url: context.coordinator.url, coordinator: context.coordinator))
    }
}
