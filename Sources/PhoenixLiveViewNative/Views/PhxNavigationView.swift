//
//  PhxNavigationView.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxNavigationView<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    
    init(element: Element, context: LiveContext<R>) {
        self.element = element
        self.context = context
    }
    
    var body: some View {
        NavigationView {
            context.buildChildren(of: element)
            // todo: make this configurable
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
