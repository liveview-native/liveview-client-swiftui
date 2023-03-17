//
//  HStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct HStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @Attribute("alignment") private var alignment: VerticalAlignment = .center
    @Attribute("spacing") private var spacing: Double?
    
    public var body: some View {
        SwiftUI.HStack(
            alignment: alignment,
            spacing: spacing.flatMap(CGFloat.init)
        ) {
            context.buildChildren(of: element)
        }
    }
}
