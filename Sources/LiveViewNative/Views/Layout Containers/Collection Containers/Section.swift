//
//  Section.swift
//  
//
//  Created by Carson Katri on 2/2/23.
//

import SwiftUI

struct Section<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        #if os(macOS)
        self.section
            .collapsible(isCollapsible)
        #else
        self.section
        #endif
    }
    
    private var isCollapsible: Bool {
        guard let collapsible = element.attribute(named: "collapsible")
        else { return false }
        guard let value = collapsible.value
        else { return true }
        return Bool(value) ?? false
    }
    
    private var section: SwiftUI.Section<some View, some View, some View> {
        SwiftUI.Section {
            context.buildChildren(of: element, withTagName: "content", namespace: "section", includeDefaultSlot: true)
        } header: {
            context.buildChildren(of: element, withTagName: "header", namespace: "section")
        } footer: {
            context.buildChildren(of: element, withTagName: "footer", namespace: "section")
        }
    }
}
