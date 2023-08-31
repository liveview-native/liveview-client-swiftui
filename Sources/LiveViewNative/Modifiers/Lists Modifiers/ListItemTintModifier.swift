//
//  ListItemTintModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/13/2023.
//

import SwiftUI

/// Sets the tint for a list item.
///
/// Apply this modifier to child elements of a ``List`` to set their tint.
///
/// See ``LiveViewNative/SwiftUI/ListItemTint`` for more details on creating tints.
///
/// ```html
/// <List>
///     <Label system-image="gear" id="gear">Default</Label>
///     <Label
///         modifiers={list_item_tint(:monochrome)}
///         system-image="square.lefthalf.filled" id="monochrome"
///     >
///         Monochrome
///     </Label>
///     <Label
///         modifiers={list_item_tint({:fixed, :red})}
///         system-image="paintpalette.fill" id="fixed"
///     >
///         Fixed Red
///     </Label>
///     <Label
///         modifiers={list_item_tint({:preferred, :red})}
///         system-image="swatchpalette.fill" id="preferred"
///     >
///         Preferred Red
///     </Label>
/// </List>
/// ```
///
/// ## Arguments
/// * ``tint``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ListItemTintModifier: ViewModifier, Decodable {
    /// The tint value.
    ///
    /// If `nil`, the default system is used.
    ///
    /// See ``LiveViewNative/SwiftUI/ListItemTint`` for more details on creating tints.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let tint: ListItemTint?

    func body(content: Content) -> some View {
        content.listItemTint(tint)
    }
}
