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
    
    @Attribute("alignment") private var alignment: Alignment = .center
    @Attribute("horizontal-spacing") private var horizontalSpacing: Double?
    @Attribute("vertical-spacing") private var verticalSpacing: Double?
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.Grid(
            alignment: alignment,
            horizontalSpacing: horizontalSpacing.flatMap(CGFloat.init),
            verticalSpacing: verticalSpacing.flatMap(CGFloat.init)
        ) {
            context.buildChildren(of: element)
        }
    }
}
