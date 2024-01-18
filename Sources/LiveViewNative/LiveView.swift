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
public macro LiveView<Host: LiveViewHost>(
    _ host: Host,
    configuration: LiveSessionConfiguration = .init(),
    addons: [any CustomRegistry<EmptyRegistry>.Type] = [],
    @ViewBuilder connecting: () -> any View = { EmptyView() },
    @ViewBuilder disconnected: () -> any View = { EmptyView() },
    @ViewBuilder error: @escaping (Error) -> any View = { _ in EmptyView() }
) -> AnyView = #externalMacro(module: "LiveViewNativeMacros", type: "LiveViewMacro")

/// The SwiftUI root view for a Phoenix LiveView.
///
/// The `LiveView` attempts to connect immediately when it appears.
///
/// While in states other than ``LiveSessionState/connected``, this view only provides a basic text description of the state. The loading view can be customized with a custom registry and the ``CustomRegistry/loadingView(for:state:)-6jd3b`` method.
///
/// ## Topics
/// ### Creating a LiveView
/// - ``init(session:)``
/// ### Supporting Types
/// - ``body``
/// ### See Also
/// - ``LiveViewModel``
public struct LiveView<R: RootRegistry>: View {
    @StateObject var session: LiveSessionCoordinator<R>
    
    @StateObject private var liveViewModel = LiveViewModel()
    
    @Environment(\.scenePhase) private var scenePhase
    
    /// Creates a new LiveView attached to the given coordinator.
    ///
    /// - Note: Changing coordinators after the `LiveView` is setup and connected is forbidden.
    public init(session: @autoclosure @escaping () -> LiveSessionCoordinator<R>) {
        self._session = .init(wrappedValue: session())
    }
    
    public init(_ host: some LiveViewHost, configuration: LiveSessionConfiguration = .init()) {
        self.init(session: .init(host.url, config: configuration))
    }
    
    public init(url: URL, configuration: LiveSessionConfiguration = .init()) {
        self.init(session: .init(url, config: configuration))
    }
    
    private var rootCoordinator: LiveViewCoordinator<R> {
        session.navigationPath.first!.coordinator
    }

    public var body: some View {
        SwiftUI.Group {
            switch session.state {
            case .connected:
                if let rootLayout = session.rootLayout {
                    self.rootCoordinator.builder.fromNodes(rootLayout[rootLayout.root()].children(), coordinator: rootCoordinator, url: rootCoordinator.url)
                        .environment(\.coordinatorEnvironment, CoordinatorEnvironment(rootCoordinator, document: rootLayout))
                } else {
                    PhxMain<R>()
                        .environment(\.coordinatorEnvironment, CoordinatorEnvironment(rootCoordinator, document: rootCoordinator.document!))
                        .environment(\.anyLiveContextStorage, LiveContextStorage(coordinator: rootCoordinator, url: rootCoordinator.url))
                }
            default:
                if R.LoadingView.self == Never.self {
                    switch session.state {
                    case .connected:
                        fatalError()
                    case .notConnected:
                        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                            SwiftUI.ContentUnavailableView {
                                SwiftUI.Label("No Connection", systemImage: "network.slash")
                            } description: {
                                SwiftUI.Text("The app will reconnect when network connection is regained.")
                            }
                        }
                    case .connecting:
                        SwiftUI.ProgressView("Connecting")
                    case .connectionFailed(let error):
                        if let error = error as? LiveConnectionError,
                           case let .initialFetchUnexpectedResponse(_, trace?) = error
                        {
                            ErrorView<R>(html: trace)
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
                    }
                } else {
                    R.loadingView(for: session.url, state: session.state)
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

extension LiveView where R == EmptyRegistry {
    public init(_ host: some LiveViewHost, configuration: LiveSessionConfiguration = .init()) {
        self.init(session: .init(host.url, config: configuration))
    }
    
    public init(url: URL, configuration: LiveSessionConfiguration = .init()) {
        self.init(session: .init(url, config: configuration))
    }
}
