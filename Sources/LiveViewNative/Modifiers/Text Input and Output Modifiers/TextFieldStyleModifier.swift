//
//  TextFieldStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/6/2023.
//

import SwiftUI

/// Sets the style for ``TextField`` child elements.
///
/// Any child ``TextField`` will be given the specified ``style``.
///
/// ```html
/// <VStack modifiers={text_field_style(@native, style: :plain)}>
///     <TextField value-binding="email">Email</TextField>
///     <TextField value-binding="password">Password</TextField>
/// </VStack>
/// ```
///
/// See ``TextFieldStyle`` for a list of possible styles.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TextFieldStyleModifier: ViewModifier, Decodable {
    /// The style to apply.
    ///
    /// See ``TextFieldStyle`` for a list of possible styles.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: TextFieldStyle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.style = try container.decode(TextFieldStyle.self, forKey: .style)
    }

    func body(content: Content) -> some View {
        content.applyTextFieldStyle(style)
    }

    enum CodingKeys: String, CodingKey {
        case style
    }
}
