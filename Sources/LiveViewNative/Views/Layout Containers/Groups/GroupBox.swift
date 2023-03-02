//
//  GroupBox.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

struct GroupBox<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    @Attribute("title") private var title: String?
    @Attribute("group-box-style") private var style: GroupBoxStyle = .automatic

    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.Group {
            if let title {
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
        .applyGroupBoxStyle(style)
    }
}

fileprivate enum GroupBoxStyle: String, AttributeDecodable {
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
