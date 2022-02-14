//
//  PhxNavigationView.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxNavigationView: View {
    private let element: Element
    private let context: LiveContext
    
    init(element: Element, context: LiveContext) {
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
