//
//  ControlGroup.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

struct ControlGroup<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>

    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.Group {
            SwiftUI.ControlGroup {
                context.buildChildren(of: element, withTagName: "content", namespace: "control-group", includeDefaultSlot: true)
            } label: {
                context.buildChildren(of: element, withTagName: "label", namespace: "control-group")
            }
        }
        .applyControlGroupStyle(element.attributeValue(for: "control-group-style").flatMap(ControlGroupStyle.init) ?? .automatic)
    }
}

fileprivate enum ControlGroupStyle: String {
    case automatic
    case navigation
}

fileprivate extension View {
    @ViewBuilder
    func applyControlGroupStyle(_ style: ControlGroupStyle) -> some View {
        switch style {
        case .automatic:
            self.controlGroupStyle(.automatic)
        case .navigation:
            self.controlGroupStyle(.navigation)
        }
    }
}
#endif
