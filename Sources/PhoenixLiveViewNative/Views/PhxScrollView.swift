//
//  PhxScrollView.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct PhxScrollView<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self._element = ObservedElement(element: element, context: context)
        self.context = context
    }
    
    public var body: some View {
        ScrollView {
            context.buildChildren(of: element)
        }
    }
}
