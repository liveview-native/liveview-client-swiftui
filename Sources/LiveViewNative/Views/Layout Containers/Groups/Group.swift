//
//  Group.swift
//  
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI

struct Group<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    public var body: some View {
        SwiftUI.Group {
            context.buildChildren(of: element)
        }
    }
}
