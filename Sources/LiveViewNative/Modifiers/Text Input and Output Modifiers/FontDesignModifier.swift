//
//  FontDesignModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/24/23.
//

import SwiftUI

/// Applies a font design to any element.
///
/// ```html
/// <Text modifiers={font_design(:default)}>This text is default</Text>
/// <Text modifiers={font_design(:monospaced)}>This text is monospaced</Text>
/// <Text modifiers={font_design(:rounded)}>This text is rounded</Text>
/// <Text modifiers={font_design(:serif)}>This text is serif</Text>
/// ```
///
/// ## Arguments
/// * ``design``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.1, watchOS 9.1, *)
struct FontDesignModifier: ViewModifier, Decodable, TextModifier {
    /// The font design to apply to the view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var design: Font.Design

    func body(content: Content) -> some View {
        content.fontDesign(design)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.fontDesign(design)
    }
}
