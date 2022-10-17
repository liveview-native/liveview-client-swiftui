//
//  PhxVStack.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct PhxVStack<R: CustomRegistry>: View {
    private let element: ElementNode
    private let context: LiveContext<R>
    private let alignment: HorizontalAlignment
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.element = element
        self.context = context
        switch element.attributeValue(for: "alignment") {
        case nil, "center":
            self.alignment = .center
        case "leading":
            self.alignment = .leading
        case "trailing":
            self.alignment = .trailing
        default:
            fatalError("Invalid value '\(element.attributeValue(for: "alignment")!)' for alignment attribute of <vstack>")
        }
    }

    public var body: some View {
        VStack(alignment: alignment) {
            context.buildChildren(of: element)
        }
    }
}
