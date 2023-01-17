//
//  HStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct HStack<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.HStack(alignment: alignment, spacing: spacing) {
            context.buildChildren(of: element)
        }
    }
    
    private var alignment: VerticalAlignment {
        switch element.attributeValue(for: "alignment") {
        case nil, "center":
            return .center
        case "top":
            return .top
        case "bottom":
            return .bottom
        default:
            fatalError("Invalid value '\(element.attributeValue(for: "alignment")!)' for alignment attribute of <hstack>")
        }
    }
    
    private var spacing: CGFloat? {
        element.attributeValue(for: "spacing")
            .flatMap(Double.init)
            .flatMap(CGFloat.init)
    }
}
