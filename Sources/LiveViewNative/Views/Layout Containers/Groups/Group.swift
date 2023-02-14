//
//  Group.swift
//  
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI

struct Group<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.Group {
            context.buildChildren(of: element)
        }
    }
}
