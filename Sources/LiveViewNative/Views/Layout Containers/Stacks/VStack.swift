//
//  VStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct VStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @Attribute("alignment") private var alignment: HorizontalAlignment = .center
    @Attribute("spacing") private var spacing: Double?
    
    public var body: some View {
        SwiftUI.VStack(
            alignment: alignment,
            spacing: spacing.flatMap(CGFloat.init)
        ) {
            context.buildChildren(of: element)
        }
    }
}
