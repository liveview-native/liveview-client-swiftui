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
    
    @Attribute("destination", transform: { $0?.value.flatMap(URL.init(string:)) }) private var destination: URL?
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.Link(
            destination: destination!
        ) {
            context.buildChildren(of: element)
        }
    }
}
