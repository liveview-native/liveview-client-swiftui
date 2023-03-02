//
//  NavigationLink.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 6/13/22.
//

import SwiftUI
import Combine

@available(iOS 16.0, *)
struct NavigationLink<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    @EnvironmentObject private var navCoordinator: NavigationCoordinator<R>
    @State private var doNavigationCancellable: AnyCancellable?
    
    @Attribute("destination") private var destination: String
    @Attribute("disabled") private var disabled: Bool
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    @ViewBuilder
    public var body: some View {
        SwiftUI.NavigationLink(
            value: LiveNavigationEntry(
                url: URL(string: destination, relativeTo: context.coordinator.url)!.appending(path: "").absoluteURL,
                coordinator: context.coordinator
            )
        ) {
            context.buildChildren(of: element)
        }
        .disabled(disabled)
    }
}
