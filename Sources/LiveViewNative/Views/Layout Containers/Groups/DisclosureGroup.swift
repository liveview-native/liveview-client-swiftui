//
//  DisclosureGroup.swift
//
//
//  Created by Carson Katri on 2/22/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

struct DisclosureGroup<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    @LiveBinding(attribute: "is-expanded") private var isExpanded = false

    init(context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.DisclosureGroup(isExpanded: $isExpanded) {
            context.buildChildren(of: element, withTagName: "content", namespace: "disclosure-group", includeDefaultSlot: true)
        } label: {
            context.buildChildren(of: element, withTagName: "label", namespace: "disclosure-group", includeDefaultSlot: false)
        }
        .applyDisclosureGroupStyle(element.attributeValue(for: "disclosure-group-style").flatMap(DisclosureGroupStyle.init) ?? .automatic)
    }
}

fileprivate enum DisclosureGroupStyle: String {
    case automatic
}

fileprivate extension View {
    @ViewBuilder
    func applyDisclosureGroupStyle(_ style: DisclosureGroupStyle) -> some View {
        switch style {
        case .automatic:
            self.disclosureGroupStyle(.automatic)
        }
    }
}
#endif
