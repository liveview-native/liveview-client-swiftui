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
/// While in states other than ``LiveViewCoordinator/State-swift.enum/connected``, this view only provides a basic text description of the state. The loading view can be customized with a custom registry and the ``CustomRegistry/loadingView(for:state:)-vg2v`` method.
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
    @StateObject private var navigationCoordinator: NavigationCoordinator<R>
    @State private var hasSetupNavigationControllerDelegate = false
    
    /// Creates a new LiveView attached to the given coordinator.
    ///
    /// - Note: Changing coordinators after the `LiveView` is setup and connected is forbidden.
    public init(coordinator: LiveViewCoordinator<R>) {
        self._navigationCoordinator = .init(wrappedValue: .init(initialCoordinator: coordinator))
    }

    public var body: some View {
        rootNavEntry
            .task {
                await navigationCoordinator.initialCoordinator.connect()
            }
    }
        
    @ViewBuilder
    private var rootNavEntry: some View {
        if case .enabled = navigationCoordinator.initialCoordinator.config.navigationMode {
            if UIDevice.current.userInterfaceIdiom == .pad {
                navigationSplitView
            } else {
                navigationStack
            }
        } else {
            NavStackEntryView(coordinator: navigationCoordinator.initialCoordinator)
        }
    }
    
    @ViewBuilder
    private var navigationStack: some View {
        NavigationStack(path: $navigationCoordinator.navigationPath) {
            navigationRoot
                .navigationDestination(for: URL.self) { url in
                    if let coordinator = navigationCoordinator.coordinator(for: url) {
                        NavStackEntryView(coordinator: coordinator)
                            .environmentObject(navigationCoordinator)
                    }
                }
        }
    }
    @ViewBuilder
    private var navigationSplitView: some View {
        NavigationSplitView {
            navigationRoot
        } detail: {
            if let url = navigationCoordinator.navigationPath.last,
               let coordinator = navigationCoordinator.coordinator(for: url) {
                NavStackEntryView(coordinator: coordinator)
                    .environmentObject(navigationCoordinator)
            }
        }
    }
    
    private var navigationRoot: some View {
        NavStackEntryView(coordinator: navigationCoordinator.initialCoordinator)
            .environmentObject(navigationCoordinator)
    }
    
}
