//
//  PhxModernNavigationLink.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 6/13/22.
//

import SwiftUI
import Combine

@available(iOS 16.0, *)
struct PhxModernNavigationLink<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let disabled: Bool
    private let linkOpts: LinkOptions?
    @EnvironmentObject private var navCoordinator: NavAnimationCoordinator
    @State private var source: HeroViewSourceKey.Value = nil
    @State private var coordinatorStateCancellable: AnyCancellable?
    
    init(element: Element, context: LiveContext<R>) {
        self.element = element
        self.context = context
        self.disabled = element.hasAttr("disabled")
        self.linkOpts = LinkOptions(element: element)
    }
    
    @ViewBuilder
    var body: some View {
        if let linkOpts = linkOpts,
           context.coordinator.config.navigationMode.supportsLinkState(linkOpts.state) {
            Button(action: activateNavigationLink) {
                context.buildChildren(of: element)
                    .onPreferenceChange(HeroViewSourceKey.self) { newSource in
                        source = newSource
                    }
            }
            .disabled(disabled)
        } else {
            // if there are no link options, or the coordinator doesn't support the required navigation, we don't show anything
        }
    }
    
    private func activateNavigationLink() {
        guard let linkOpts = linkOpts else {
            return
        }
        
        let dest = URL(string: linkOpts.href, relativeTo: context.url)!
        context.coordinator.navigateTo(url: dest, replace: linkOpts.state == .replace)
        
        switch linkOpts.state {
        case .replace:
            navCoordinator.navigationPath[navCoordinator.navigationPath.count - 1] = dest
            
        case .push:
            func doPushNavigation() {
                navCoordinator.sourceRect = source?.globalFrame ?? .zero
                navCoordinator.sourceElement = source?.element
                navCoordinator.navigationPath.append(dest)
            }
            
            // if there's no animation source, we trigger the navigation immediately so that it feels more responsive
            guard source != nil else {
                doPushNavigation()
                return
            }
            
            // if connecting is too slow, navigate immediately without the custom animation
            let triggerNavigationWorkItem = DispatchWorkItem {
                doPushNavigation()
                // cancel the connection state subscription
                coordinatorStateCancellable = nil
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150), execute: triggerNavigationWorkItem)
            
            coordinatorStateCancellable = context.coordinator.$state
                .sink { newState in
                    if case .connecting = newState {
                    } else {
                        // once we connect to the destination, if we haven't been cancelled (it's been <150ms), navigate
                        doPushNavigation()
                        // cancel the delayed navigationj
                        triggerNavigationWorkItem.cancel()
                        // after connecting, we don't need to listen for further state changes
                        coordinatorStateCancellable = nil
                    }
                }
        }
    }
    
}
