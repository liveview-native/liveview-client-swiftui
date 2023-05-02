//
//  KerningModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets the spacing, or kerning, between characters for the text in this view.
///
/// ```html
/// <Text modifiers={kerning(@native, kerning: 0.2)}>
///     Hello, world!
/// </Text>
/// ```
///
/// ## Arguments
/// * ``kerning``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct KerningModifier: ViewModifier, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let kerning: CGFloat

    func body(content: Content) -> some View {
        content.kerning(kerning)
    }
}
