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
/// ## State Views
/// When in states other than ``LiveSessionState/connected``, this View will use a default indicator.
/// Provide the `connecting`, `disconnected`, `reconnected`, and `error` arguments to customize the presentation of the state.
///
/// ```swift
/// LiveView(.localhost) {
///     ProgressView("Loading")
/// } disconnected: {
///     Text("No connection")
/// }
/// ```
///
/// The `reconnecting` closure is provided the contents of the LiveView before it lost connection.
/// Use the `content` parameter to add an overlay to the previously rendered LiveView content.
///
/// ```swift
/// LiveView(.localhost) {
///     ProgressView("Loading")
/// } reconnecting: { content in
///     content.overlay(alignment: .bottom) {
///         Text("Reconnecting")
///     }
/// }
/// ```
///
/// The `reconnecting` closure can also take a second argument: a `Bool` indicating whether the View is reconnecting or connected.
/// If you provide a closure with both arguments, any modifiers will always be applied. It is up to you to conditionally render the reconnecting state.
/// This form can be useful when animating the reconnection indicator.
///
/// ```swift
/// LiveView(.localhost) {
///     ProgressView("Loading")
/// } reconnecting: { content, isReconnecting in
///     content
///         .overlay(alignment: .bottom) {
///             if isReconnecting {
///                 Text("Reconnecting")
///                     .transition(.move(edge: .bottom))
///             }
///         }
///         .animation(.default, value: isReconnecting)
/// }
/// ```
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
    
    @ViewBuilder
    var connectedContent: some View {
        if let rootLayout = session.rootLayout {
            self.rootCoordinator.builder.fromNodes(rootLayout[rootLayout.root()].children(), coordinator: rootCoordinator, url: rootCoordinator.url)
                .environment(\.coordinatorEnvironment, CoordinatorEnvironment(rootCoordinator, document: rootLayout))
        } else {
            PhxMain<R>()
                .environment(\.coordinatorEnvironment, CoordinatorEnvironment(rootCoordinator, document: rootCoordinator.document!))
                .environment(\.anyLiveContextStorage, LiveContextStorage(coordinator: rootCoordinator, url: rootCoordinator.url))
        }
    }
    
    public var body: some View {
        SwiftUI.Group {
            switch session.state {
            case .connected, .reconnecting:
                if ReconnectingView.self == Never.self {
                    connectedContent
                } else {
                    reconnectingView(
                        AnyView(
                            connectedContent
                        ),
                        session.state.isReconnecting
                    )
                }
            case .notConnected:
                if DisconnectedView.self != Never.self {
                    disconnectedView()
                }
            case .connecting:
                if ConnectingView.self != Never.self {
                    connectingView()
                }
            case .connectionFailed(let error):
                if ErrorView.self != Never.self {
                    errorView(error)
                }
            }
        }
        .environment(\.liveViewStateViews, LiveViewStateViews(
            connecting: connectingView,
            disconnected: disconnectedView,
            reconnecting: reconnectingView,
            error: errorView
        ))
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

/// Type-erased collection of state views, passed through the `Environment` for use in `NavStackEntryView`.
struct LiveViewStateViews {
    let connectingView: () -> AnyView
    let disconnectedView: () -> AnyView
    let reconnectingView: (AnyView, Bool) -> AnyView
    let errorView: (Error) -> AnyView
    
    init<ConnectingView: View, DisconnectedView: View, ReconnectingView: View, ErrorView: View>(
        connecting: @escaping () -> ConnectingView,
        disconnected: @escaping () -> DisconnectedView,
        reconnecting: @escaping (AnyView, Bool) -> ReconnectingView,
        error errorView: @escaping (Error) -> ErrorView
    ) {
        self.connectingView = {
            if ConnectingView.self != Never.self {
                AnyView(connecting())
            } else {
                AnyView(EmptyView())
            }
        }
        self.disconnectedView = {
            if DisconnectedView.self != Never.self {
                AnyView(connecting())
            } else {
                AnyView(EmptyView())
            }
        }
        self.reconnectingView = { content, isReconnecting in
            if ReconnectingView.self != Never.self {
                AnyView(reconnecting(content, isReconnecting))
            } else {
                AnyView(content)
            }
        }
        self.errorView = { error in
            if ErrorView.self != Never.self {
                AnyView(errorView(error))
            } else {
                AnyView(EmptyView())
            }
        }
    }
}
extension EnvironmentValues {
    enum LiveViewStateViewsKey: EnvironmentKey {
        static let defaultValue = LiveViewStateViews(connecting: { fatalError() }, disconnected: { fatalError() }, reconnecting: { _, _ in fatalError() }, error: { _ in fatalError() })
    }
    
    var liveViewStateViews: LiveViewStateViews {
        get { self[LiveViewStateViewsKey.self] }
        set { self[LiveViewStateViewsKey.self] = newValue }
    }
}
