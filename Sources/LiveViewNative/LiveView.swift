//
//  LiveView.swift
//  LiveViewTest
//
//  Created by Brian Cardarella on 4/28/21.
//

import Foundation
import SwiftUI
import Combine

#if swift(>=5.9)
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
    addons: [any CustomRegistry<EmptyRegistry>.Type]
) -> AnyView = #externalMacro(module: "LiveViewNativeMacros", type: "LiveViewMacro")
#endif

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
    @State private var hasAppeared = false
    
    @StateObject var storage: LiveSessionCoordinatorStorage
    
    @State private var hasSetupNavigationControllerDelegate = false
    
    @ObservedObject private var rootCoordinator: LiveViewCoordinator<R>
    
    /// Creates a new LiveView attached to the given coordinator.
    ///
    /// - Note: Changing coordinators after the `LiveView` is setup and connected is forbidden.
    public init(session: LiveSessionCoordinator<R>) {
        self._storage = .init(wrappedValue: .init(session: session))
        self.rootCoordinator = session.rootCoordinator
    }
    
    public init(_ host: some LiveViewHost, configuration: LiveSessionConfiguration = .init()) {
        self.init(session: .init(host.url, config: configuration))
    }
    
    public init(url: URL, configuration: LiveSessionConfiguration = .init()) {
        self.init(session: .init(url, config: configuration))
    }
    
    final class LiveSessionCoordinatorStorage: ObservableObject {
        var session: LiveSessionCoordinator<R>
        
        var cancellable: AnyCancellable?
        
        init(session: LiveSessionCoordinator<R>) {
            self.session = session
            self.cancellable = session.objectWillChange.sink { [weak self] _ in
                self?.objectWillChange.send()
            }
        }
    }

    public var body: some View {
        SwiftUI.VStack {
            switch storage.session.state {
            case .connected:
                rootNavEntry
            default:
                if R.LoadingView.self == Never.self {
                    switch storage.session.state {
                    case .connected:
                        fatalError()
                    case .notConnected:
                        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                            #if swift(>=5.9)
                            SwiftUI.ContentUnavailableView {
                                SwiftUI.Label("No Connection", systemImage: "network.slash")
                            } description: {
                                SwiftUI.Text("The app will reconnect when network connection is regained.")
                            }
                            #else
                            SwiftUI.Text("Not Connected")
                            #endif
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
                                #if swift(>=5.9)
                                SwiftUI.ContentUnavailableView {
                                    SwiftUI.Label("No Connection", systemImage: "network.slash")
                                } description: {
                                    SwiftUI.Text("The app will reconnect when network connection is regained.")
                                }
                                #else
                                SwiftUI.VStack {
                                    SwiftUI.Text("Connection Failed")
                                        .font(.subheadline)
                                    SwiftUI.Text(error.localizedDescription)
                                }
                                #endif
                            } else {
                                SwiftUI.VStack {
                                    SwiftUI.Text("Connection Failed")
                                        .font(.subheadline)
                                    SwiftUI.Text(error.localizedDescription)
                                }
                            }
                        }
                    }
                } else {
                    R.loadingView(for: storage.session.url, state: storage.session.state)
                }
            }
        }
            .task {
                await storage.session.connect()
            }
    }
        
    @ViewBuilder
    private var rootNavEntry: some View {
        switch storage.session.configuration.navigationMode {
        case .enabled:
            navigationStack
        case .splitView:
            navigationSplitView
        case let .tabView(tabs):
            tabView(tabs)
        default:
            navigationRoot
        }
    }
    
    @ViewBuilder
    private var navigationStack: some View {
        NavigationStack(path: $storage.session.navigationPath) {
            navigationRoot
                .navigationDestination(for: LiveNavigationEntry<R>.self) { entry in
                    NavStackEntryView(entry)
                }
        }
    }
    @ViewBuilder
    private var navigationSplitView: some View {
        NavigationSplitView {
            navigationRoot
        } detail: {
            NavigationStack(path: Binding<[LiveNavigationEntry<R>]> {
                Array(storage.session.navigationPath.dropFirst())
            } set: { value in
                var result = value
                if let first = storage.session.navigationPath.first {
                    result.insert(first, at: 0)
                }
                storage.session.navigationPath = result
            }) {
                SwiftUI.Group {
                    if let entry = storage.session.navigationPath.first {
                        NavStackEntryView(entry)
                    }
                }
                .navigationDestination(for: LiveNavigationEntry<R>.self) { entry in
                    NavStackEntryView(entry)
                }
            }
        }
    }
    
    @State private var selectedTab: URL?
    @ViewBuilder
    private func tabView(_ tabs: [LiveSessionConfiguration.NavigationMode.Tab]) -> some View {
        SwiftUI.TabView(selection: $selectedTab) {
            ForEach(tabs) { tab in
                NavigationStack(path: $storage.session.navigationPath) {
                    NavStackEntryView(.init(url: selectedTab ?? storage.session.url, coordinator: rootCoordinator))
                        .navigationDestination(for: LiveNavigationEntry<R>.self) { entry in
                            NavStackEntryView(entry)
                        }
                }
                    .tabItem {
                        tab.label
                    }
                    .tag(URL?.some(tab.url))
            }
        }
        .onChange(of: selectedTab) { newValue in
            guard let newValue else { return }
            Task {
                storage.session.rootCoordinator.url = newValue
                await storage.session.reconnect()
            }
        }
    }
    
    private var navigationRoot: some View {
        NavStackEntryView(.init(url: storage.session.url, coordinator: rootCoordinator))
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
