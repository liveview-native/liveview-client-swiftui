//
//  Group.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

struct GridRow<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.GridRow(alignment: alignment) {
            context.buildChildren(of: element)
        }
    }
    
    private var alignment: VerticalAlignment? {
        switch element.attributeValue(for: "alignment") {
        case "center":
            return .center
        case "top":
            return .top
        case "bottom":
            return .bottom
        default:
            return nil
        }
    }
}
