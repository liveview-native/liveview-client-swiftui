//
//  MenuStyleModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/12/23.
//

import SwiftUI

/// Applies a style to a ``Menu`` view.
///
/// The `button` style may be combined with the ``ButtonStyleModifier`` modifier to alter the button's appearance.
///
/// ```html
/// <Menu modifiers={menu_style(:button) |> button_style(style: :bordered_prominent)}>
///     <Text template={:label}>
///         Edit Actions
///     </Text>
///     <Group template={:content}>
///         <Button phx-click="arrange">Arrange</Button>
///         <Button phx-click="update">Update</Button>
///         <Button phx-click="remove">Remove</Button>
///     </Group>
/// </Menu>
/// ```
///
/// ## Arguments
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``MenuStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
struct MenuStyleModifier: ViewModifier, Decodable {
    /// The menu style to apply.
    ///
    /// See ``MenuStyle`` for possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: MenuStyle
    
    func body(content: Content) -> some View {
#if !os(watchOS)
        switch style {
        case .automatic:
            content.menuStyle(.automatic)
        case .button:
            content.menuStyle(.button)
        }
#endif
    }
}

#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum MenuStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case button
}
