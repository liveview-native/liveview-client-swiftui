//
//  VStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct VStack<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.VStack(
            alignment: element.attributeValue(for: "alignment").flatMap(HorizontalAlignment.init) ?? .center,
            spacing: spacing
        ) {
            context.buildChildren(of: element)
        }
    }
    
    private var spacing: CGFloat? {
        element.attributeValue(for: "spacing")
            .flatMap(Double.init)
            .flatMap(CGFloat.init)
    }
}
