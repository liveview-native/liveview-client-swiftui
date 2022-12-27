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
    private let coordinator: LiveViewCoordinator<R>
    @State private var hasAppeared = false
    @StateObject private var navigationCoordinator = NavigationCoordinator()
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
                    let proxy = ProxyingNavigationControllerDelegate(first: navigationCoordinator, second: existing)
                    self.navigationControllerDelegateProxy = proxy
                    navigationController.delegate = proxy
                } else {
                    navigationController.delegate = navigationCoordinator
                }
                
                navigationController.interactivePopGestureRecognizer?.addTarget(navigationCoordinator, action: #selector(NavigationCoordinator.interactivePopRecognized))
            }
            .overlay {
                if navigationCoordinator.state.isAnimating,
                   !UIAccessibility.prefersCrossFadeTransitions {
                    GeometryReader { _ in
                        navHeroOverlayView
                            .frame(width: navigationCoordinator.currentRect.width, height: navigationCoordinator.currentRect.height)
                            .clipped()
                            // if we use the GeometryReader, the offset is with respect to the global origin,
                            // if not, it's with respect to the center of the screen.
                            // so, we wrap the view in a GeometryReader, but don't actually use the proxy
                            .offset(x: navigationCoordinator.currentRect.minX, y: navigationCoordinator.currentRect.minY)
                            .allowsHitTesting(false)
                            .animation(navigationCoordinator.state.animation, value: navigationCoordinator.currentRect)
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        } else {
            NavStackEntryView(coordinator: coordinator, url: coordinator.initialURL)
        }
    }
    
    @ViewBuilder
    private var navHeroOverlayView: some View {
        // some views (AsyncImage) don't work properly when used in the animation
        // so they can be overriden with a preference
        if let overrideView = navigationCoordinator.overrideOverlayView {
            overrideView
        } else {
            coordinator.builder.fromNodes(navigationCoordinator.sourceElement!.children(), coordinator: coordinator, url: coordinator.currentURL)
        }
    }
    
    @ViewBuilder
    private var navigationViewOrStack: some View {
        NavigationStack(path: $navigationCoordinator.navigationPath) {
            navigationRoot
                .navigationDestination(for: URL.self) { url in
                    NavStackEntryView(coordinator: coordinator, url: url)
                        .environmentObject(navigationCoordinator)
                        .onPreferenceChange(HeroViewDestKey.self) { newDest in
                            if let newDest {
                                navigationCoordinator.destRect = newDest.frameProvider()
                                navigationCoordinator.destElement = newDest.element
                            }
                        }
                }
        }
        .onReceive(navigationCoordinator.$navigationPath.zip(navigationCoordinator.$navigationPath.dropFirst())) { (oldValue, newValue) in
            // when navigating backwards, we need to reconnect to the old page
            // this is done here, because PhxModernNavigationLink does't know when it's popped
            // navigating forward is handled by the link, in order to do the hero transition
            if oldValue.count > newValue.count {
                let dest = newValue.last ?? coordinator.initialURL
                Task {
                    await coordinator.navigateTo(url: dest)
                }
            }
        }
    }
    
    private var navigationRoot: some View {
        NavStackEntryView(coordinator: coordinator, url: coordinator.initialURL)
            .environmentObject(navigationCoordinator)
    }
    
}
