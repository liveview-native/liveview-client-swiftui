//
//  GridRow.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

struct GridRow<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @Attribute("alignment") private var alignment: VerticalAlignment?

    public var body: some View {
        SwiftUI.GridRow(alignment: alignment) {
            context.buildChildren(of: element)
        }
    }
}
