//
//  ControlGroup.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

struct ControlGroup<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    @Attribute("control-group-style") private var style: ControlGroupStyle = .automatic

    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }

    public var body: some View {
        SwiftUI.ControlGroup {
            context.buildChildren(of: element, withTagName: "content", namespace: "ControlGroup", includeDefaultSlot: true)
        } label: {
            context.buildChildren(of: element, withTagName: "label", namespace: "ControlGroup")
        }
        .applyControlGroupStyle(style)
    }
}

fileprivate enum ControlGroupStyle: String, AttributeDecodable {
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
