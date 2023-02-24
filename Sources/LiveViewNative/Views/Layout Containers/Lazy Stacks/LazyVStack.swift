//
//  LazyVStack.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI

struct LazyVStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.LazyVStack(
            alignment: element.attributeValue(for: "alignment").flatMap(HorizontalAlignment.init) ?? .center,
            spacing: spacing,
            pinnedViews: element.attributeValue(for: "pinned-views").flatMap(PinnedScrollableViews.init) ?? []
        ) {
            context.buildChildren(of: element)
        }
    }
    
    private var spacing: CGFloat? {
        element.attributeValue(for: "spacing")
            .flatMap(Double.init)
            .flatMap(CGFloat.init)
    }
}
