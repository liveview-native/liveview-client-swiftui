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
    private let element: ElementNode
    private let context: LiveContext<R>
    private let disabled: Bool
    private let linkOpts: LinkOptions?
    @EnvironmentObject private var navCoordinator: NavigationCoordinator
    @State private var source: HeroViewSourceKey.Value = nil
    @State private var overrideView: HeroViewOverrideKey.Value = nil
    @State private var doNavigationCancellable: AnyCancellable?
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.element = element
        self.context = context
        self.disabled = element.attribute(named: "disabled") != nil
        self.linkOpts = LinkOptions(element: element)
    }
    
    @ViewBuilder
    public var body: some View {
        if let linkOpts = linkOpts,
           context.coordinator.config.navigationMode.supportsLinkState(linkOpts.state) {
            ZStack {
                // need a NavigationLink present to display the disclosure indicator
                NavigationLink(isActive: .constant(false)) { EmptyView() } label: { EmptyView() }
                
                Button{
                    activateNavigationLink()
                } label: {
                    context.buildChildren(of: element)
                        .onPreferenceChange(HeroViewSourceKey.self) { newSource in
                            source = newSource
                        }
                        .onPreferenceChange(HeroViewOverrideKey.self) { newOverrideView in
                            overrideView = newOverrideView
                        }
                }
                .disabled(disabled)
            }
        } else {
            // if there are no link options, or the coordinator doesn't support the required navigation, we don't show anything
        }
    }
    
    private func activateNavigationLink() {
        guard let linkOpts = linkOpts else {
            return
        }
        
        let dest = URL(string: linkOpts.href, relativeTo: context.url)!
        
        switch linkOpts.state {
        case .replace:
            navCoordinator.navigationPath[navCoordinator.navigationPath.count - 1] = dest
            Task {
                await context.coordinator.navigateTo(url: dest, replace: true)
            }
            
        case .push:
            func doPushNavigation() {
                navCoordinator.sourceRect = source?.frameProvider() ?? .zero
                navCoordinator.sourceElement = source?.element
                navCoordinator.overrideOverlayView = overrideView?.view
                navCoordinator.navigationPath.append(dest)
            }
            
            // if there's no animation source, we trigger the navigation immediately so that it feels more responsive
            guard source != nil else {
                Task {
                    await context.coordinator.navigateTo(url: dest, replace: false)
                }
                // TODO: when this happens, swiftui warns that publishing changes from within a view update is not allowed
                // even though this is happening in a button action, not sure why
                doPushNavigation()
                return
            }
            
            let subject = PassthroughSubject<Void, Never>()
            doNavigationCancellable = subject
                // whichever happens first, connection or timeout, do the navigation
                .first()
                .sink { _ in
                    doPushNavigation()
                }
            
            Task {
                await context.coordinator.navigateTo(url: dest, replace: false)
                subject.send()
            }
            
            // if connecting is too slow, navigate immediately without the custom animation
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
                subject.send()
            }
        }
    }
    
}
