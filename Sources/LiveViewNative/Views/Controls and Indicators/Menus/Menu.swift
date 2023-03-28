//
//  Menu.swift
//  
//
//  Created by Carson Katri on 1/19/23.
//
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
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
struct Menu<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The style to apply to this menu.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("menu-style") private var style: MenuStyle = .automatic
    
    public var body: some View {
        #if !os(watchOS)
        SwiftUI.Menu {
            context.buildChildren(of: element, withTagName: "content", namespace: "Menu")
        } label: {
            context.buildChildren(of: element, withTagName: "label", namespace: "Menu", includeDefaultSlot: true)
        }
        .applyMenuStyle(style)
        #endif
    }
}

#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum MenuStyle: String, AttributeDecodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    /// `borderless-button`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case borderlessButton = "borderless-button"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case button
}

fileprivate extension View {
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
    @ViewBuilder
    func applyMenuStyle(_ style: MenuStyle) -> some View {
#if !os(watchOS)
        switch style {
        case .automatic:
            self.menuStyle(.automatic)
        case .borderlessButton:
            self.menuStyle(.borderlessButton)
        case .button:
            self.menuStyle(.button)
        }
#endif
    }
}
