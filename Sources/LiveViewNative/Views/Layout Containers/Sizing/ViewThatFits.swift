//
//  ViewThatFits.swift
//
//
//  Created by Carson Katri on 2/21/23.
//

import SwiftUI

struct ViewThatFits<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    @Attribute("axes") private var axes: Axis.Set = [.horizontal, .vertical]
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.ViewThatFits(
            in: axes
        ) {
            context.buildChildren(of: element)
        }
    }
}
