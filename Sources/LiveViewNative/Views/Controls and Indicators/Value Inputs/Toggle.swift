//
//  Toggle.swift
//
//
//  Created by Carson Katri on 1/17/23.
//

import SwiftUI

struct Toggle<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    @FormState(default: false) var value: Bool
    
    @Attribute("toggle-style") private var style: ToggleStyle = .automatic
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.Toggle(isOn: $value) {
            context.buildChildren(of: element)
        }
        .applyToggleStyle(style)
    }
}

fileprivate enum ToggleStyle: String, AttributeDecodable {
    case automatic
    case button
    case `switch`
#if os(macOS)
    case checkbox
#endif
}

fileprivate extension View {
    @ViewBuilder
    func applyToggleStyle(_ style: ToggleStyle) -> some View {
        switch style {
        case .automatic:
            self.toggleStyle(.automatic)
        case .button:
            self.toggleStyle(.button)
        case .`switch`:
            self.toggleStyle(.switch)
#if os(macOS)
        case .checkbox:
            self.toggleStyle(.checkbox)
#endif
        }
    }
}
