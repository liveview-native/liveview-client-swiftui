//
//  LiveView.swift
//  LiveViewTest
//
//  Created by Brian Cardarella on 4/28/21.
//

import Foundation
import SwiftUI
import Combine
import LiveViewNativeCore

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
    addons: [Addons],
    @ViewBuilder connecting: @escaping () -> ConnectingView = { () -> Never in fatalError() },
    @ViewBuilder disconnected: @escaping () -> DisconnectedView = { () -> Never in fatalError() },
    @ViewBuilder reconnecting: @escaping (_ConnectedContent<EmptyRegistry>, Bool) -> ReconnectingView = { (_: _ConnectedContent<EmptyRegistry>, _: Bool) -> Never in fatalError() },
    @ViewBuilder error: @escaping (Error) -> ErrorView = { (_: Error) -> Never in fatalError() }
) -> AnyView = #externalMacro(module: "LiveViewNativeMacros", type: "LiveViewMacro")

@freestanding(expression)
public macro LiveView<
    Host: LiveViewHost,
    PhaseView: View
>(
    _ host: Host,
    configuration: LiveSessionConfiguration = .init(),
    addons: [any CustomRegistry<EmptyRegistry>.Type] = [],
    @ViewBuilder content: @escaping (LiveViewPhase<EmptyRegistry>) -> PhaseView = { (_: LiveViewPhase<EmptyRegistry>) -> Never in fatalError() }
) -> AnyView = #externalMacro(module: "LiveViewNativeMacros", type: "LiveViewMacro")

@freestanding(expression)
public macro LiveView<
    Host: LiveViewHost,
    PhaseView: View
>(
    _ host: Host,
    configuration: LiveSessionConfiguration = .init(),
    addons: [Addons],
    @ViewBuilder content: @escaping (LiveViewPhase<EmptyRegistry>) -> PhaseView = { (_: LiveViewPhase<EmptyRegistry>) -> Never in fatalError() }
) -> AnyView = #externalMacro(module: "LiveViewNativeMacros", type: "LiveViewMacro")

public struct EventConfirmationTransaction: Sendable {
    let message: String
    let callback: @Sendable (sending Bool) -> ()
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
@MainActor
public struct LiveView<
    R: RootRegistry,
    PhaseView: View,
    ConnectingView: View,
    DisconnectedView: View,
    ReconnectingView: View,
    ErrorView: View
>: View {
    @StateObject var session: LiveSessionCoordinator<R>
    
    @Environment(\.scenePhase) private var scenePhase
    
    let phaseView: (LiveViewPhase<R>) -> PhaseView
    let connectingView: () -> ConnectingView
    let disconnectedView: () -> DisconnectedView
    let reconnectingView: (_ConnectedContent<R>, Bool) -> ReconnectingView
    let errorView: (Error) -> ErrorView
    
    
    @MainActor
    @ViewBuilder
    func buildPhaseView(_ phase: LiveViewPhase<R>) -> some View {
        if PhaseView.self != Never.self {
            phaseView(phase)
                .transition(session.configuration.transition ?? .identity)
        } else {
            switch phase {
            case let .connected(content),
                 let .reconnecting(content):
                SwiftUI.Group {
                    if ReconnectingView.self != Never.self {
                        reconnectingView(content, !phase.isConnected)
                    } else {
                        content
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
            case .disconnected:
                SwiftUI.Group {
                    if DisconnectedView.self != Never.self {
                        disconnectedView()
                    }
                }
                .transition(session.configuration.transition ?? .identity)
            case let .error(error):
                SwiftUI.Group {
                    if ErrorView.self != Never.self {
                        errorView(error)
                    }
                }
                .transition(session.configuration.transition ?? .identity)
            }
        }
    }
    
    var phase: LiveViewPhase<R> {
        switch session.state {
        case .connected:
            return .connected(_ConnectedContent<R>(session: session))
        case .connecting:
            return .connecting
        case let .connectionFailed(error):
            
            if let error = error as? LiveViewNativeCore.LiveSocketError,
               case let .ConnectionError(connectionError) = error {
                if let channel = connectionError.livereloadChannel {
                    Task { @MainActor [weak session] in
                        try await session?.overrideLiveReloadChannel(channel: channel)
                    }
                }
            }
            
            return .error(error)
        case .setup:
            return .connecting
        case .disconnected:
            return .disconnected
        case .reconnecting:
            return .reconnecting(_ConnectedContent<R>(session: session))
        }
    }
    
    @MainActor
    public var body: some View {
        SwiftUI.Group {
            buildPhaseView(phase)
        }
        .animation(session.configuration.transition.map({ _ in .default }), value: session.state.isConnected)
        .transformEnvironment(\.liveViewStateViews) { stateViews in
            stateViews[ObjectIdentifier(R.self)] = { phase in
                AnyView(buildPhaseView(phase as! LiveViewPhase<R>))
            }
        }
        .environment(\.stylesheet, session.stylesheet ?? .init(content: [], classes: [:]))
        .environment(\.reconnectLiveView, .init(baseURL: session.url, action: session.reconnect))
        .environmentObject(session)
        .task {
            await session.connect()
        }
        .onChange(of: scenePhase) { newValue in
            guard case .active = newValue
            else { return }
            if case .connected = session.socket?.status() {
                return
            }
            Task {
                await session.connect()
            }
        }
        // data-confirm
        .environment(\.eventConfirmation, session.configuration.eventConfirmation ?? { [weak session] message, _ in
            return await withCheckedContinuation { continuation in
                if let session = session {
                    session.eventConfirmationTransaction = EventConfirmationTransaction(message: message, callback: continuation.resume(returning:))
                    session.showEventConfirmation = true
                } else {
                    continuation.resume(returning: false)
                }
            }
        })
        .confirmationDialog(
            session.eventConfirmationTransaction?.message ?? "",
            isPresented: $session.showEventConfirmation,
            titleVisibility: .visible,
            presenting: session.eventConfirmationTransaction
        ) { transaction in
            SwiftUI.Button("OK") {
                transaction.callback(true)
            }
            SwiftUI.Button("Cancel", role: .cancel) {
                transaction.callback(false)
            }
        }
    }
    
}

/// The `<div data-phx-main>` element.
struct PhxMain<R: RootRegistry>: View {
    @LiveContext<R> private var context
    @EnvironmentObject private var session: LiveSessionCoordinator<R>
    
    var body: some View {
        NavStackEntryView(.init(url: context.coordinator.url, coordinator: context.coordinator, navigationTransition: nil, pendingView: nil))
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

extension EnvironmentValues {
    enum LiveViewStateViewsKey: EnvironmentKey {
        static let defaultValue: [ObjectIdentifier: @MainActor (Any) -> AnyView] = [:]
    }
    
    var liveViewStateViews: [ObjectIdentifier: @MainActor (Any) -> AnyView] {
        get { self[LiveViewStateViewsKey.self] }
        set { self[LiveViewStateViewsKey.self] = newValue }
    }
}

extension LiveView where PhaseView == Never {
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
        self.phaseView = { _ in fatalError() }
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
}

extension LiveView where ConnectingView == Never, DisconnectedView == Never, ReconnectingView == Never, ErrorView == Never {
    public init(
        registry _: R.Type = EmptyRegistry.self,
        session: @autoclosure @escaping () -> LiveSessionCoordinator<R>,
        @ViewBuilder content: @escaping (LiveViewPhase<R>) -> PhaseView
    ) {
        self._session = .init(wrappedValue: session())
        self.phaseView = content
        self.connectingView = { fatalError() }
        self.disconnectedView = { fatalError() }
        self.reconnectingView = { _, _ in fatalError() }
        self.errorView = { _ in fatalError() }
    }
    
    public init(
        registry: R.Type = EmptyRegistry.self,
        _ host: some LiveViewHost,
        configuration: LiveSessionConfiguration = .init(),
        @ViewBuilder content: @escaping (LiveViewPhase<R>) -> PhaseView
    ) {
        self.init(
            registry: registry,
            session: .init(host.url, config: configuration),
            content: content
        )
    }
    
    public init(
        registry: R.Type = EmptyRegistry.self,
        url: URL,
        configuration: LiveSessionConfiguration = .init(),
        @ViewBuilder content: @escaping (LiveViewPhase<R>) -> PhaseView
    ) {
        self.init(
            registry: registry,
            session: .init(url, config: configuration),
            content: content
        )
    }
}
