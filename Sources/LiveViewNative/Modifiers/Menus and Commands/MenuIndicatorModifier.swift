//
//  MenuIndicatorVisibilityModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/12/23.
//

import SwiftUI

/// Specifies whether the indicator on a ``Menu`` should be visible.
///
/// ```html
/// <Menu modifiers={menu_style(:button) |> menu_indicator(visibility: :hidden)}>
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
/// - ``visibility``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
struct MenuIndicatorModifier: ViewModifier, Decodable {
    /// The indicator visibility.
    ///
    /// See ``LiveViewNative/SwiftUI/Visibility`` for possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let visibility: Visibility
    
    func body(content: Content) -> some View {
        content
            #if !os(watchOS)
            .menuIndicator(visibility)
            #endif
    }
}
