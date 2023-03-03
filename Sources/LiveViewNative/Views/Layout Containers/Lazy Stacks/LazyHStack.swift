//
//  LazyVStack.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI

struct LazyHStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    @Attribute("alignment") private var alignment: VerticalAlignment = .center
    @Attribute("spacing") private var spacing: Double?
    @Attribute("pinned-views") private var pinnedViews: PinnedScrollableViews = []
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.LazyHStack(
            alignment: alignment,
            spacing: spacing.flatMap(CGFloat.init),
            pinnedViews: pinnedViews
        ) {
            context.buildChildren(of: element)
        }
    }
}
