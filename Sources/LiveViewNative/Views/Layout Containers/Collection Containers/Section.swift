//
//  Section.swift
//  
//
//  Created by Carson Katri on 2/2/23.
//

import SwiftUI

struct Section<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @Attribute("collapsible") private var collapsible: Bool
    
    public var body: some View {
        SwiftUI.Section {
            context.buildChildren(of: element, withTagName: "content", namespace: "Section", includeDefaultSlot: true)
        } header: {
            context.buildChildren(of: element, withTagName: "header", namespace: "Section")
        } footer: {
            context.buildChildren(of: element, withTagName: "footer", namespace: "Section")
        }
        #if os(macOS)
            .collapsible(collapsible)
        #endif
    }
}
