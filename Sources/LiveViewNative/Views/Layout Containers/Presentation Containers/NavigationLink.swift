//
//  NavigationLink.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 6/13/22.
//

import SwiftUI
import Combine

@available(iOS 16.0, *)
struct NavigationLink<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    @EnvironmentObject private var navCoordinator: NavigationCoordinator<R>
    @State private var doNavigationCancellable: AnyCancellable?
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    @ViewBuilder
    public var body: some View {
        if let linkOpts = LinkOptions(element: element),
           context.coordinator.session.config.navigationMode.supportsLinkState(linkOpts.state),
           let url = linkOpts.url(in: context)
        {
            SwiftUI.NavigationLink(value: LiveNavigationEntry(url: url, coordinator: context.coordinator)) {
                context.buildChildren(of: element)
            }
            .disabled(element.attribute(named: "disabled") != nil)
        } else {
            // if there are no link options, or the coordinator doesn't support the required navigation, we don't show anything
        }
    }
}

struct LinkOptions {
    let kind: LinkKind
    let state: LiveRedirect.Kind
    let href: String
    
    init?(element: ElementNode) {
        guard let kindStr = element.attributeValue(for: "data-phx-link"),
              let kind = LinkKind(rawValue: kindStr),
              let stateStr = element.attributeValue(for: "data-phx-link-state"),
              let state = LiveRedirect.Kind(rawValue: stateStr) else {
            return nil
        }
        self.kind = kind
        self.state = state
        self.href = element.attributeValue(for: "data-phx-href")!
    }
    
    @MainActor
    func url<R: CustomRegistry>(in context: LiveContext<R>) -> URL? {
        .init(string: href, relativeTo: context.coordinator.url)?.appending(path: "/").absoluteURL
    }
}

enum LinkKind: String {
    case redirect
}

extension LiveSessionConfiguration.NavigationMode {
    func supportsLinkState(_ state: LiveRedirect.Kind) -> Bool {
        switch self {
        case .disabled:
            return false
        case .replaceOnly:
            return state == .replace
        case .enabled, .splitView:
            return true
        }
    }
}
