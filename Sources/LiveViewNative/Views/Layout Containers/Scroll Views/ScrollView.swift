//
//  ScrollView.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct ScrollView<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    @Attribute("axes") private var axes: Axis.Set = .vertical
    @Attribute("shows-indicators") private var showsIndicators: Bool
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.ScrollView(
            axes,
            showsIndicators: showsIndicators
        ) {
            context.buildChildren(of: element)
        }
    }
}
