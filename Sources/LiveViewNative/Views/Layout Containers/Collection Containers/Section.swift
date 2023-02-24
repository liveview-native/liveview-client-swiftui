//
//  Section.swift
//  
//
//  Created by Carson Katri on 2/2/23.
//

import SwiftUI

struct Section<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.Section {
            context.buildChildren(of: element, withTagName: "content", namespace: "section", includeDefaultSlot: true)
        } header: {
            context.buildChildren(of: element, withTagName: "header", namespace: "section")
        } footer: {
            context.buildChildren(of: element, withTagName: "footer", namespace: "section")
        }
        #if os(macOS)
            .collapsible(element.attributeBoolean(for: "collapsible"))
        #endif
    }
}
