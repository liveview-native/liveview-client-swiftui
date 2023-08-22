//
//  FontModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/5/2023.
//

import SwiftUI

/// Changes the font for child elements.
///
/// Pass a ``LiveViewNative/SwiftUI/Font`` to the ``font`` argument to change the value.
///
/// ```html
/// <Text modifiers={font({:system, :large_title, [design: :serif]})}>
///     Hello, world!
/// </Text>
/// ```
///
/// See ``LiveViewNative/SwiftUI/Font`` for more details on creating fonts.
///
/// ## Arguments
/// * ``font``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct FontModifier: ViewModifier, Decodable, TextModifier {
    /// The font to use for child elements.
    ///
    /// See ``LiveViewNative/SwiftUI/Font`` for more details on creating fonts.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let font: Font

    func body(content: Content) -> some View {
        content.font(font)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.font(font)
    }
}
