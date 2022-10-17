//
//  PhxScrollView.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct PhxScrollView<R: CustomRegistry>: View {
    let element: ElementNode
    let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.element = element
        self.context = context
    }
    
    public var body: some View {
        ScrollView {
            context.buildChildren(of: element)
        }
    }
}
