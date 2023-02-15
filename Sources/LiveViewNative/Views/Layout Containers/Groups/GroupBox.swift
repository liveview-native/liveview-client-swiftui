//
//  GroupBox.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

struct GroupBox<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>

    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.Group {
            if let title = element.attributeValue(for: "title") {
                SwiftUI.GroupBox(title) {
                    context.buildChildren(of: element)
                }
            } else {
                SwiftUI.GroupBox {
                    context.buildChildren(of: element, withTagName: "content", namespace: "group-box", includeDefaultSlot: true)
                } label: {
                    context.buildChildren(of: element, withTagName: "label", namespace: "group-box")
                }
            }
        }
        .applyGroupBoxStyle(element.attributeValue(for: "group-box-style").flatMap(GroupBoxStyle.init) ?? .automatic)
    }
}

fileprivate enum GroupBoxStyle: String {
    case automatic
}

fileprivate extension View {
    @ViewBuilder
    func applyGroupBoxStyle(_ style: GroupBoxStyle) -> some View {
        switch style {
        case .automatic:
            self.groupBoxStyle(.automatic)
        }
    }
}
#endif
