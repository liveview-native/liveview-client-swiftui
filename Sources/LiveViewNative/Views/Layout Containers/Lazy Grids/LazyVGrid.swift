//
//  LazyVGrid.swift
//
//
//  Created by Carson Katri on 2/15/23.
//

import SwiftUI

struct LazyVGrid<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @Attribute(
        "columns",
        transform: {
            guard let value = $0?.value?.data(using: .utf8) else { throw AttributeDecodingError.missingAttribute([GridItem].self) }
            return try JSONDecoder().decode([GridItem].self, from: value)
        }
    ) private var columns: [GridItem]
    @Attribute("alignment") private var alignment: HorizontalAlignment = .center
    @Attribute("spacing") private var spacing: Double?
    @Attribute("pinned-views") private var pinnedViews: PinnedScrollableViews = []
    
    public var body: some View {
        SwiftUI.LazyVGrid(
            columns: columns,
            alignment: alignment,
            spacing: spacing.flatMap(CGFloat.init),
            pinnedViews: pinnedViews
        ) {
            context.buildChildren(of: element)
        }
    }
}
