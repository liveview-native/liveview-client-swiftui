//
//  Menu.swift
//  
//
//  Created by Carson Katri on 1/19/23.
//
#if !os(watchOS)
import SwiftUI

/// Tappable element that expands to reveal a list of options.
///
/// Provide the `content` and `label` children to create a menu.
///
///
/// ```html
/// <Menu>
///     <Menu:label>
///         Edit Actions
///     </Menu:label>
///     <Menu:content>
///         <Button phx-click="arrange">Arrange</Button>
///         <Button phx-click="update">Update</Button>
///         <Button phx-click="remove">Remove</Button>
///     </Menu:content>
/// </Menu>
/// ```
///
/// Menus can be nested by including another ``Menu`` in the `content`.
///
/// ## Attributes
/// * ``style``
///
/// ## Children
/// * `label` - Describes the content of the menu.
/// * `content` - Elements displayed when expanded.
struct Menu<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    /// The style to apply to this menu.
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
    /// `borderless-button`
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
