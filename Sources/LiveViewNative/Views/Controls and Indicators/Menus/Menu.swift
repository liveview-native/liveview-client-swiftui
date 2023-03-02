//
//  Menu.swift
//  
//
//  Created by Carson Katri on 1/19/23.
//
#if !os(watchOS)
import SwiftUI

struct Menu<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    @Attribute("menu-style") private var style: MenuStyle = .automatic
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.Menu {
            context.buildChildren(of: element, withTagName: "content", namespace: "menu")
        } label: {
            context.buildChildren(of: element, withTagName: "label", namespace: "menu", includeDefaultSlot: true)
        }
        .applyMenuStyle(style)
    }
}

fileprivate enum MenuStyle: String, AttributeDecodable {
    case automatic
    case borderlessButton = "borderless-button"
    case button
}

fileprivate extension View {
    @ViewBuilder
    func applyMenuStyle(_ style: MenuStyle) -> some View {
        switch style {
        case .automatic:
            self.menuStyle(.automatic)
        case .borderlessButton:
            self.menuStyle(.borderlessButton)
        case .button:
            self.menuStyle(.button)
        }
    }
}
#endif
