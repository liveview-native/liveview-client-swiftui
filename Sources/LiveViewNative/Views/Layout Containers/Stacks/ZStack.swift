//
//  ZStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct ZStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @Attribute("alignment") private var alignment: Alignment = .center
    
    public var body: some View {
        SwiftUI.ZStack(alignment: alignment) {
            context.buildChildren(of: element)
        }
    }
}
