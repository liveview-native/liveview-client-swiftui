//
//  PhxVStack.swift
// LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct PhxVStack<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        VStack(alignment: alignment) {
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
}
