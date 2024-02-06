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
    @ViewBuilder reconnecting: @escaping (_ConnectedContent<EmptyRegistry>, Bool) -> ReconnectingView = { (_: _ConnectedContent<EmptyRegistry>, _: Bool) -> Never in fatalError() },
    @ViewBuilder error: @escaping (Error) -> ErrorView = { (_: Error) -> Never in fatalError() }
) -> AnyView = #externalMacro(module: "LiveViewNativeMacros", type: "LiveViewMacro")

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
    let reconnectingView: (_ConnectedContent<R>, Bool) -> ReconnectingView
    let isReconnectingViewStateless: Bool
    let errorView: (Error) -> ErrorView
    
    /// Creates a new LiveView attached to the given coordinator.
    ///
    /// - Note: Changing coordinators after the `LiveView` is setup and connected is forbidden.
    public init(
        registry _: R.Type = EmptyRegistry.self,
        session: @autoclosure @escaping () -> LiveSessionCoordinator<R>,
        @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
        @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
        @ViewBuilder reconnecting: @escaping (_ConnectedContent<R>, Bool) -> ReconnectingView = { (_: _ConnectedContent<R>, _: Bool) -> Never in fatalError() },
        @ViewBuilder error: @escaping (Error) -> ErrorView = { (_: Error) -> Never in fatalError() }
    ) {
        self._session = .init(wrappedValue: session())
        self.connectingView = connecting
        self.disconnectedView = disconnected
        self.reconnectingView = reconnecting
        self.isReconnectingViewStateless = false
        self.errorView = error
    }
    
    public init(
        registry: R.Type = EmptyRegistry.self,
        _ host: some LiveViewHost,
        configuration: LiveSessionConfiguration = .init(),
        @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
        @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
        @ViewBuilder reconnecting: @escaping (_ConnectedContent<R>, Bool) -> ReconnectingView = { (_: _ConnectedContent<R>, _: Bool) -> Never in fatalError() },
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
        @ViewBuilder reconnecting: @escaping (_ConnectedContent<R>, Bool) -> ReconnectingView = { (_: _ConnectedContent<R>, _: Bool) -> Never in fatalError() },
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
    
    public init(
        registry: R.Type = EmptyRegistry.self,
        session: @autoclosure @escaping () -> LiveSessionCoordinator<R>,
        @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
        @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
        @ViewBuilder reconnecting: @escaping (_ConnectedContent<R>) -> ReconnectingView = { (_: _ConnectedContent<R>) -> Never in fatalError() },
        @ViewBuilder error: @escaping (Error) -> ErrorView = { (_: Error) -> Never in fatalError() }
    ) {
        self._session = .init(wrappedValue: session())
        self.connectingView = connecting
        self.disconnectedView = disconnected
        self.reconnectingView = { content, _ in reconnecting(content) }
        self.isReconnectingViewStateless = true
        self.errorView = error
    }
    
    public init(
        registry: R.Type = EmptyRegistry.self,
        _ host: some LiveViewHost,
        configuration: LiveSessionConfiguration = .init(),
        @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
        @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
        @ViewBuilder reconnecting: @escaping (_ConnectedContent<R>) -> ReconnectingView = { (_: _ConnectedContent<R>) -> Never in fatalError() },
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
        @ViewBuilder reconnecting: @escaping (_ConnectedContent<R>) -> ReconnectingView = { (_: _ConnectedContent<R>) -> Never in fatalError() },
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
    
    public var body: some View {
        SwiftUI.Group {
            switch session.state {
            case .connected, .reconnecting:
                SwiftUI.Group {
                    if ReconnectingView.self == Never.self {
                        _ConnectedContent<R>(session: session)
                    } else {
                        reconnectingView(
                            _ConnectedContent<R>(session: session),
                            session.state.isReconnecting
                        )
                    }
                }
                .transition(session.configuration.transition ?? .identity)
            case .notConnected:
                SwiftUI.Group {
                    if DisconnectedView.self != Never.self {
                        disconnectedView()
                    }
                }
                .transition(session.configuration.transition ?? .identity)
            case .connecting:
                SwiftUI.Group {
                    if ConnectingView.self != Never.self {
                        connectingView()
                    }
                }
                .transition(session.configuration.transition ?? .identity)
            case .connectionFailed(let error):
                SwiftUI.Group {
                    if ErrorView.self != Never.self {
                        errorView(error)
                    }
                }
                .transition(session.configuration.transition ?? .identity)
            }
        }
        .animation(session.configuration.transition.map({ _ in .default }), value: session.state.isConnected)
        .transformEnvironment(\.liveViewStateViews) { stateViews in
            stateViews[ObjectIdentifier(R.self)] = LiveViewStateViews<R>(
                connecting: connectingView,
                disconnected: disconnectedView,
                reconnecting: reconnectingView,
                error: errorView
            )
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

/// The `<div data-phx-main>` element.
struct PhxMain<R: RootRegistry>: View {
    @LiveContext<R> private var context
    @EnvironmentObject private var session: LiveSessionCoordinator<R>
    
    var body: some View {
        NavStackEntryView(.init(url: context.coordinator.url, coordinator: context.coordinator))
    }
}

/// The content of a ``LiveView`` when connected/reconnecting.
public struct _ConnectedContent<R: RootRegistry>: View {
    @ObservedObject var session: LiveSessionCoordinator<R>
    
    private var rootCoordinator: LiveViewCoordinator<R> {
        session.navigationPath.first!.coordinator
    }
    
    public var body: some View {
        if let rootLayout = session.rootLayout {
            self.rootCoordinator.builder.fromNodes(rootLayout[rootLayout.root()].children(), coordinator: rootCoordinator, url: rootCoordinator.url)
                .environment(\.coordinatorEnvironment, CoordinatorEnvironment(rootCoordinator, document: rootLayout))
        } else {
            PhxMain<R>()
                .environment(\.coordinatorEnvironment, CoordinatorEnvironment(rootCoordinator, document: rootCoordinator.document!))
                .environment(\.anyLiveContextStorage, LiveContextStorage(coordinator: rootCoordinator, url: rootCoordinator.url))
        }
    }
}

/// Type-erased collection of state views, passed through the `Environment` for use in `NavStackEntryView`.
struct LiveViewStateViews<R: RootRegistry> {
    let connectingView: () -> AnyView
    let disconnectedView: () -> AnyView
    let reconnectingView: (_ConnectedContent<R>, Bool) -> AnyView
    let errorView: (Error) -> AnyView
    
    init<ConnectingView: View, DisconnectedView: View, ReconnectingView: View, ErrorView: View>(
        connecting: @escaping () -> ConnectingView,
        disconnected: @escaping () -> DisconnectedView,
        reconnecting: @escaping (_ConnectedContent<R>, Bool) -> ReconnectingView,
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
        static let defaultValue: [ObjectIdentifier:Any] = [:]
    }
    
    var liveViewStateViews: [ObjectIdentifier:Any] {
        get { self[LiveViewStateViewsKey.self] }
        set { self[LiveViewStateViewsKey.self] = newValue }
    }
}
