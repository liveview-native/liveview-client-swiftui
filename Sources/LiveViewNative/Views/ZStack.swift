//
//  ZStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct ZStack<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.ZStack(alignment: alignment) {
            context.buildChildren(of: element)
        }
    }
    
    private var alignment: Alignment {
        if let s = element.attributeValue(for: "alignment"), let alignment = Alignment(string: s) {
            return alignment
        } else {
            return .center
        }
    }
}
