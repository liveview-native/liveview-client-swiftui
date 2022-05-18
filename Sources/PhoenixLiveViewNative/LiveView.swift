//
//  LiveView.swift
//  LiveViewTest
//
//  Created by Brian Cardarella on 4/28/21.
//

import Foundation
import SwiftUI
import Introspect

/// The SwiftUI root view for a Phoenix LiveView.
///
/// By default, a `LiveView` attempts to connect immediately when it appears. While in states other than ``LiveViewCoordinator/State-swift.enum/connected``, this view only provides a basic text description of the state.
public struct LiveView<R: CustomRegistry>: View {
    private let coordinator: LiveViewCoordinator<R>
    @State private var hasAppeared = false
    @StateObject private var navAnimationCoordinator = NavAnimationCoordinator()
    
    /// Creates a new LiveView attached to the given coordinator.
    ///
    /// - Note: Changing coordinators after the `LiveView` is setup and connected is forbidden.
    public init(coordinator: LiveViewCoordinator<R>) {
        self.coordinator = coordinator
    }

    public var body: some View {
        rootNavEntry
            .onAppear {
                if !hasAppeared {
                    hasAppeared = true
                    coordinator.connect()
                }
            }
    }
        
    @ViewBuilder
    private var rootNavEntry: some View {
        if case .enabled = coordinator.config.navigationMode {
            NavigationView {
                NavStackEntryView(coordinator: coordinator, url: coordinator.initialURL)
                    .environmentObject(navAnimationCoordinator)
            }
            .introspectNavigationController { navigationController in
                // if SwiftUI in the future starts using the delegate, we don't want to override it
                // the custom transition will stop working, but at least it'll fail gracefully
                if navigationController.delegate == nil {
                    navigationController.delegate = navAnimationCoordinator
                }
            }
            .overlay {
                if navAnimationCoordinator.state.isAnimating,
                   !UIAccessibility.prefersCrossFadeTransitions {
                    GeometryReader { _ in
                        coordinator.builder.fromElements(navAnimationCoordinator.sourceElement!.children(), coordinator: coordinator, url: coordinator.currentURL)
                            .frame(width: navAnimationCoordinator.currentRect.width, height: navAnimationCoordinator.currentRect.height)
                            // if we use the GeometryReader, the offset is with respect to the global origin,
                            // if not, it's with respect to the center of the screen.
                            // so, we wrap the view in a GeometryReader, but don't actually use the proxy
                            .offset(x: navAnimationCoordinator.currentRect.minX, y: navAnimationCoordinator.currentRect.minY)
                            .allowsHitTesting(false)
                            // 0.35 seconds is as close as I can get to the builtin nav transition duration
                            .animation(.easeOut(duration: 0.35), value: navAnimationCoordinator.currentRect)
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        } else {
            NavStackEntryView(coordinator: coordinator, url: coordinator.initialURL)
        }
    }
    
}
