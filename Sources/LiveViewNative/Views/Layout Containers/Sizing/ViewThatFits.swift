//
//  ViewThatFits.swift
//
//
//  Created by Carson Katri on 2/21/23.
//

import SwiftUI

struct ViewThatFits<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.ViewThatFits(
            in: element.attributeValue(for: "axes").flatMap(Axis.Set.init(string:)) ?? [.horizontal, .vertical]
        ) {
            context.buildChildren(of: element)
        }
    }
}
