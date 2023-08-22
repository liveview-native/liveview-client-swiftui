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
/// <Text modifiers={kerning(0.2)}>
///     Hello, world!
/// </Text>
/// ```
///
/// ## Arguments
/// * ``kerning``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct KerningModifier: ViewModifier, Decodable, TextModifier {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let kerning: CGFloat

    func body(content: Content) -> some View {
        content.kerning(kerning)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.kerning(kerning)
    }
}
