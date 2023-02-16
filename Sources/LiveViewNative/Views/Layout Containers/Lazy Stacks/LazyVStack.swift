//
//  LazyVStack.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI

struct LazyVStack<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.LazyVStack(alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
            context.buildChildren(of: element)
        }
    }
    
    private var alignment: HorizontalAlignment {
        switch element.attributeValue(for: "alignment") {
        case nil, "center":
            return .center
        case "leading":
            return .leading
        case "trailing":
            return .trailing
        default:
            fatalError("Invalid value '\(element.attributeValue(for: "alignment")!)' for alignment attribute of <lazy-v-stack>")
        }
    }
    
    private var spacing: CGFloat? {
        element.attributeValue(for: "spacing")
            .flatMap(Double.init)
            .flatMap(CGFloat.init)
    }
    
    private var pinnedViews: PinnedScrollableViews {
        switch element.attributeValue(for: "pinned-views") {
        case "section-headers":
            return .sectionHeaders
        case "section-footers":
            return .sectionFooters
        case "all":
            return [.sectionHeaders, .sectionFooters]
        default:
            return .init()
        }
    }
}
