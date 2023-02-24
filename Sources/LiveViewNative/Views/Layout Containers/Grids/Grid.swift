//
//  Grid.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

struct Grid<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.Grid(
            alignment: element.attributeValue(for: "alignment").flatMap(Alignment.init(string:)) ?? .center,
            horizontalSpacing: element.attributeValue(for: "horizontal-spacing").flatMap(Double.init(_:)).flatMap(CGFloat.init),
            verticalSpacing: element.attributeValue(for: "vertical-spacing").flatMap(Double.init(_:)).flatMap(CGFloat.init)
        ) {
            context.buildChildren(of: element)
        }
    }
}
