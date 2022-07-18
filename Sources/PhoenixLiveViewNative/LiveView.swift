//
//  LiveView.swift
//  LiveViewTest
//
//  Created by Brian Cardarella on 4/28/21.
//

import Foundation
import SwiftUI
import Introspect
import LVNObjC

/// The SwiftUI root view for a Phoenix LiveView.
///
/// By default, a `LiveView` attempts to connect immediately when it appears. While in states other than ``LiveViewCoordinator/State-swift.enum/connected``, this view only provides a basic text description of the state.
public struct LiveView<R: CustomRegistry>: View {
    private let coordinator: LiveViewCoordinator<R>
    @State private var hasAppeared = false
    @StateObject private var navAnimationCoordinator = NavAnimationCoordinator()
    @State private var hasSetupNavigationControllerDelegate = false
    @State private var navigationControllerDelegateProxy: ProxyingNavigationControllerDelegate?
    
    /// Creates a new LiveView attached to the given coordinator.
    ///
    /// - Note: Changing coordinators after the `LiveView` is setup and connected is forbidden.
    public init(coordinator: LiveViewCoordinator<R>) {
        self.coordinator = coordinator
    }

    public var body: some View {
        rootNavEntry
            .task {
                // TODO: the hasAppeared check may not be necessary with .task
                if !hasAppeared {
                    hasAppeared = true
                    await coordinator.connect()
                }
            }
    }
        
    @ViewBuilder
    private var rootNavEntry: some View {
        if case .enabled = coordinator.config.navigationMode {
            navigationViewOrStack
            .introspectNavigationController { navigationController in
                guard !hasSetupNavigationControllerDelegate else {
                    return
                }
                hasSetupNavigationControllerDelegate = true
                
                if let existing = navigationController.delegate {
                    let proxy = ProxyingNavigationControllerDelegate(first: navAnimationCoordinator, second: existing)
                    self.navigationControllerDelegateProxy = proxy
                    navigationController.delegate = proxy
                } else {
                    navigationController.delegate = navAnimationCoordinator
                }
                
                navigationController.interactivePopGestureRecognizer?.addTarget(navAnimationCoordinator, action: #selector(NavAnimationCoordinator.interactivePopRecognized))
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
                            .animation(navAnimationCoordinator.state.animation, value: navAnimationCoordinator.currentRect)
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        } else {
            NavStackEntryView(coordinator: coordinator, url: coordinator.initialURL)
        }
    }
    
    @ViewBuilder
    private var navigationViewOrStack: some View {
        if #available(iOS 16.0, *) {
            NavigationStack(path: $navAnimationCoordinator.navigationPath) {
                navigationRoot
                    .navigationDestination(for: URL.self) { url in
                        NavStackEntryView(coordinator: coordinator, url: url)
                            .environmentObject(navAnimationCoordinator)
                            .onPreferenceChange(HeroViewDestKey.self) { newDest in
                                if let newDest {
                                    navAnimationCoordinator.destRect = newDest.globalFrame
                                    navAnimationCoordinator.destElement = newDest.element
                                }
                            }
                    }
            }
        } else {
            NavigationView {
                navigationRoot
            }
        }
    }
    
    private var navigationRoot: some View {
        NavStackEntryView(coordinator: coordinator, url: coordinator.initialURL)
            .environmentObject(navAnimationCoordinator)
    }
    
}
