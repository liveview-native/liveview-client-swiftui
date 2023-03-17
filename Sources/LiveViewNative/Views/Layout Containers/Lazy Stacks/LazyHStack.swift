//
//  LazyVStack.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI

struct LazyHStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @Attribute("alignment") private var alignment: VerticalAlignment = .center
    @Attribute("spacing") private var spacing: Double?
    @Attribute("pinned-views") private var pinnedViews: PinnedScrollableViews = []
    
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
