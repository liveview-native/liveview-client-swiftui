//
//  FontWeightModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//

import SwiftUI

/// Changes the font weight for child elements.
///
/// Pass a ``LiveViewNative/SwiftUI/Font/Weight`` to the ``weight`` argument to change the value.
///
/// ```html
/// <Text modifiers={font_weight(:bold)}>
///     Hello, world!
/// </Text>
/// ```
///
/// See ``LiveViewNative/SwiftUI/Font/Weight`` for more details on creating font weights.
///
/// ## Arguments
/// * ``weight``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct FontWeightModifier: ViewModifier, Decodable, Equatable, TextModifier {
    /// The font weight to use for child elements.
    ///
    /// See ``LiveViewNative/SwiftUI/Font/Weight`` for more details on creating font weights.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let weight: Font.Weight?

    func body(content: Content) -> some View {
        content.fontWeight(weight)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.fontWeight(weight)
    }
}
