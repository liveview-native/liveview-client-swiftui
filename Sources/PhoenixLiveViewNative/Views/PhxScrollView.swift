//
//  PhxScrollView.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxScrollView: View {
    let element: Element
    let context: LiveContext
    
    init(element: Element, context: LiveContext) {
        self.element = element
        self.context = context
    }
    
    var body: some View {
        ScrollView {
            context.buildChildren(of: element)
        }
    }
}
