//
//  ViewThatFits.swift
//
//
//  Created by Carson Katri on 2/21/23.
//

import SwiftUI

struct ViewThatFits<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @Attribute("axes") private var axes: Axis.Set = [.horizontal, .vertical]
    
    public var body: some View {
        SwiftUI.ViewThatFits(
            in: axes
        ) {
            context.buildChildren(of: element)
        }
    }
}
