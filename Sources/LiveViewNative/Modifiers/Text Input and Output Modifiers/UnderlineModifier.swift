//
//  UnderlineModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/23/2023.
//

import SwiftUI

/// Underlines ``Text`` elements.
///
/// The line can be customized with the ``pattern`` and ``color`` arguments.
///
/// ```html
/// <Text modifiers={underline(color: :red, pattern: :dash_dot)}>
///     Hello, world!
/// </Text>
/// ```
///
/// ## Arguments
/// * ``isActive``
/// * ``pattern``
/// * ``color``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct UnderlineModifier: ViewModifier, Decodable, TextModifier {
    /// `is_active`, enables/disables the effect. Defaults to `true`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let isActive: Bool

    /// The pattern to use for the line. Defaults to `solid`.
    ///
    /// See ``LiveViewNative/SwiftUI/Text/LineStyle/Pattern`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let pattern: SwiftUI.Text.LineStyle.Pattern

    /// The color of the line. Defaults to `nil`.
    ///
    /// See ``LiveViewNative/SwiftUI/Color`` for details on creating colors.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let color: SwiftUI.Color?

    func body(content: Content) -> some View {
        content.underline(isActive, pattern: pattern, color: color)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.underline(isActive, pattern: pattern, color: color)
    }
}
