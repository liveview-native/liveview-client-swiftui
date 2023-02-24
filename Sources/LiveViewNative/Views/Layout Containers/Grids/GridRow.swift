//
//  GridRow.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

struct GridRow<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.GridRow(alignment: element.attributeValue(for: "alignment").flatMap(VerticalAlignment.init)) {
            context.buildChildren(of: element)
        }
    }
}
