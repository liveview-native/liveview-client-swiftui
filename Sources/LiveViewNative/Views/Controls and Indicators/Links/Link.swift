//
//  Link.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI

struct Link<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.Link(
            destination: URL(string: element.attributeValue(for: "destination")!)!
        ) {
            context.buildChildren(of: element)
        }
    }
}
