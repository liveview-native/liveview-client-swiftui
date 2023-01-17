//
//  LiveView.swift
//  LiveViewTest
//
//  Created by Brian Cardarella on 4/28/21.
//

import Foundation
import SwiftUI

/// The SwiftUI root view for a Phoenix LiveView.
///
/// The `LiveView` attempts to connect immediately when it appears.
///
/// While in states other than ``LiveSessionCoordinator/State-swift.enum/connected``, this view only provides a basic text description of the state. The loading view can be customized with a custom registry and the ``CustomRegistry/loadingView(for:state:)-vg2v`` method.
///
/// ## Topics
/// ### Creating a LiveView
/// - ``init(coordinator:)``
/// ### Supporting Types
/// - ``body``
/// ### See Also
/// - ``LiveViewModel``
public struct LiveView<R: CustomRegistry>: View {
    @State private var hasAppeared = false
    @ObservedObject var session: LiveSessionCoordinator<R>
    @State private var hasSetupNavigationControllerDelegate = false
    
    @ObservedObject private var rootCoordinator: LiveViewCoordinator<R>
    
    /// Creates a new LiveView attached to the given coordinator.
    ///
    /// - Note: Changing coordinators after the `LiveView` is setup and connected is forbidden.
    public init(session: LiveSessionCoordinator<R>) {
        self._session = .init(wrappedValue: session)
        self.rootCoordinator = session.rootCoordinator
    }

    public var body: some View {
        SwiftUI.VStack {
            switch session.state {
            case .connected:
                rootNavEntry
            default:
                if R.LoadingView.self == Never.self {
                    switch session.state {
                    case .connected:
                        fatalError()
                    case .notConnected:
                        SwiftUI.Text("Not Connected")
                    case .connecting:
                        SwiftUI.Text("Connecting")
                    case .connectionFailed(let error):
                        SwiftUI.VStack {
                            SwiftUI.Text("Connection Failed")
                                .font(.subheadline)
                            SwiftUI.Text(error.localizedDescription)
                        }
                    }
                } else {
                    R.loadingView(for: session.url, state: session.state)
                }
            }
        }
            .task {
                await session.connect()
            }
    }
        
    @ViewBuilder
    private var rootNavEntry: some View {
        switch session.config.navigationMode {
        case .enabled:
            navigationStack
        case .splitView:
            navigationSplitView
        default:
            navigationRoot
        }
    }
    
    @ViewBuilder
    private var navigationStack: some View {
        NavigationStack(path: $session.navigationPath) {
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
                Array(session.navigationPath.dropFirst())
            } set: { value in
                var result = value
                if let first = session.navigationPath.first {
                    result.insert(first, at: 0)
                }
                session.navigationPath = result
            }) {
                Group {
                    if let entry = session.navigationPath.first {
                        NavStackEntryView(entry)
                    }
                }
                .navigationDestination(for: LiveNavigationEntry<R>.self) { entry in
                    NavStackEntryView(entry)
                }
            }
        }
    }
    
    private var navigationRoot: some View {
        NavStackEntryView(.init(url: rootCoordinator.url, coordinator: rootCoordinator))
    }
}
