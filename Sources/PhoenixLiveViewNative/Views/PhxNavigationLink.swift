//
//  PhxNavigationLink.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 4/4/22.
//

import SwiftUI

struct PhxNavigationLink<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let disabled: Bool
    private let linkOpts: LinkOptions?
    @State private var isActive = false
    
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
                NavigationLink(isActive: $isActive) {
                    NavStackEntryView(coordinator: context.coordinator, url: URL(string: linkOpts.href, relativeTo: context.url)!)
                } label: {
                    context.buildChildren(of: element)
                }
                .onChange(of: isActive, perform: { newValue in
                    if newValue {
                        // became active, so we're navigating to the new page
                        context.coordinator.navigateTo(url: URL(string: linkOpts.href, relativeTo: context.url)!)
                    } else {
                        // became inactive, so we're returning to the previous page (i.e., the page this link is on)
                        context.coordinator.navigateTo(url: context.url)
                    }
                })
                .disabled(disabled)
                
            case .replace:
                Button {
                    let newURL = URL(string: linkOpts.href, relativeTo: context.url)!
                    context.coordinator.navigateTo(url: newURL, replace: true)
                } label: {
                    context.buildChildren(of: element)
                }
                .disabled(disabled)
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
