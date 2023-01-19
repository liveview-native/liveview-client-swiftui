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
        if let href = element.attributeValue(for: "destination").flatMap({
            URL(string: $0, relativeTo: context.coordinator.url)?.appending(path: "").absoluteURL
        }) {
            SwiftUI.NavigationLink(
                value: LiveNavigationEntry(
                    url: href,
                    coordinator: context.coordinator
                )
            ) {
                context.buildChildren(of: element)
            }
            .disabled(element.attribute(named: "disabled") != nil)
        }
    }
}
