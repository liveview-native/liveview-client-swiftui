//
//  ZStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct ZStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    @Attribute("alignment") private var alignment: Alignment = .center
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.ZStack(alignment: alignment) {
            context.buildChildren(of: element)
        }
    }
}
