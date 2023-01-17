//
//  VStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct VStack<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.VStack(alignment: alignment, spacing: spacing) {
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
            fatalError("Invalid value '\(element.attributeValue(for: "alignment")!)' for alignment attribute of <vstack>")
        }
    }
    
    private var spacing: CGFloat? {
        element.attributeValue(for: "spacing")
            .flatMap(Double.init)
            .flatMap(CGFloat.init)
    }
}
