//
//  TextSelectionModifier.swift
//  
//
//  Created by Carson Katri on 4/5/23.
//

import SwiftUI

/// Enables/disables selection of ``Text``.
///
/// Use this modifier to enable selection of non-editable ``Text`` elements.
///
/// ```html
/// <Text modifiers={text_selection(true)}>
///     Hello, world!
/// </Text>
/// ```
///
/// Arguments:
/// * ``selectable``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct TextSelectionModifier: ViewModifier, Decodable {
    /// Sets the selectability of the element.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let selectable: Bool

    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS)
        if selectable {
            content.textSelection(.enabled)
        } else {
            content.textSelection(.disabled)
        }
        #else
        content
        #endif
    }
}
