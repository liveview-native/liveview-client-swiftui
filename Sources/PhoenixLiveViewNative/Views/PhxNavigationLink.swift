//
//  PhxNavigationLink.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 4/4/22.
//

import SwiftUI
import Combine

struct PhxNavigationLink<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let disabled: Bool
    private let linkOpts: LinkOptions?
    @State private var isActive = false
    @EnvironmentObject private var animationCoordinator: NavAnimationCoordinator
    @State private var source: HeroViewSourceKey.Value = nil
    @State private var coordinatorStateCancellable: AnyCancellable?
    
    init(element: Element, context: LiveContext<R>) {
        self.element = element
        self.context = context
        self.disabled = element.hasAttr("disabled")
        self.linkOpts = LinkOptions(element: element)
    }
    
    var body: some View {
        if let linkOpts = linkOpts,
           context.coordinator.config.navigationMode.supportsLinkState(linkOpts.state) {
            switch linkOpts.state {
            case .push:
                ZStack {
                    NavigationLink(isActive: $isActive) {
                        NavStackEntryView(coordinator: context.coordinator, url: URL(string: linkOpts.href, relativeTo: context.url)!)
                            .environmentObject(animationCoordinator)
                            .onPreferenceChange(HeroViewDestKey.self) { newDest in
                                animationCoordinator.destRect = newDest?.globalFrame ?? .zero
                                animationCoordinator.destElement = newDest?.element
                            }
                    } label: {
                        // empty, we use a Button to display the link so that we can delay the navigation after the tap
                    }

                    Button(action: activateNavigationLink) {
                        context.buildChildren(of: element)
                            .onPreferenceChange(HeroViewSourceKey.self) { newSource in
                                source = newSource
                            }
                    }
                    .disabled(disabled)
                }
                .onChange(of: isActive, perform: { newValue in
                    if newValue {
                        // we don't trigger the navigation when we become active; it's handled by the button action
                        animationCoordinator.sourceRect = source?.globalFrame ?? .zero
                        animationCoordinator.sourceElement = source?.element
                    } else {
                        // became inactive, so we're returning to the previous page (i.e., the page this link is on)
                        context.coordinator.navigateTo(url: context.url)
                    }
                })
                
            case .replace:
                Button {
                    let newURL = URL(string: linkOpts.href, relativeTo: context.url)!
                    context.coordinator.navigateTo(url: newURL, replace: true)
                } label: {
                    context.buildChildren(of: element)
                }
                .disabled(disabled)
            }
        } else {
            // if there are no link options, or the coordinator doesn't support the requested navigation, we don't show anything
        }
    }
    
    private func activateNavigationLink() {
        guard let linkOpts = linkOpts,
              linkOpts.state == .push else {
            return
        }
        // start the navigation process and connect to the dest live view
        context.coordinator.navigateTo(url: URL(string: linkOpts.href, relativeTo: context.url)!)
        
        // if there's no animation source, we trigger the navigation immediately so that it feels more responsive
        guard source != nil else {
            isActive = true
            return
        }
        
        // if connecting is too slow, navigate immediately without the custom animation
        let triggerNavigationWorkItem = DispatchWorkItem {
            isActive = true
            // cancel the connection state subscription
            coordinatorStateCancellable = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150), execute: triggerNavigationWorkItem)
        
        coordinatorStateCancellable = context.coordinator.$state
            .sink { newState in
                // todo: double check that the coordinator's new url is the expected one
                // :S
                if case .connecting = newState {
                } else {
                    // once we connect to the destination, if we haven't been cancelled (it's been <150ms), navigate
                    isActive = true
                    // cancel the delayed navigation
                    triggerNavigationWorkItem.cancel()
                    // after connecting, we don't need to listen for further state changes
                    coordinatorStateCancellable = nil
                }
            }
    }
}

private struct LinkOptions {
    let kind: LinkKind
    let state: LinkState
    let href: String
    
    init?(element: Element) {
        guard element.hasAttr("data-phx-link"),
              let kind = LinkKind(rawValue: try! element.attr("data-phx-link")),
              let state = LinkState(rawValue: try! element.attr("data-phx-link-state")) else {
            return nil
        }
        self.kind = kind
        self.state = state
        self.href = try! element.attr("data-phx-href")
    }
}

private enum LinkKind: String {
    case redirect
}

private enum LinkState: String {
    case push
    case replace
}

private extension LiveViewConfiguration.NavigationMode {
    func supportsLinkState(_ state: LinkState) -> Bool {
        switch self {
        case .disabled:
            return false
        case .replaceOnly:
            return state == .replace
        case .enabled:
            return true
        }
    }
}
