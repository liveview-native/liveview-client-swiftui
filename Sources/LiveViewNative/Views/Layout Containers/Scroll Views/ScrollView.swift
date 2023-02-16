//
//  ScrollView.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct ScrollView<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.ScrollView(
            element.attributeValue(for: "axes").flatMap(Axis.Set.init) ?? .vertical,
            showsIndicators: element.attributeBoolean(for: "shows-indicators")
        ) {
            context.buildChildren(of: element)
        }
    }
}
