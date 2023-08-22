//
//  ForegroundColorModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/24/23.
//

import SwiftUI

/// Applies a foreground color to a view.
/// ```html
/// <Text modifiers={foreground_color(:mint)}>
///   Minty fresh text.
/// </Text>
/// ```
///
/// ## Arguments
/// * ``color``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ForegroundColorModifier: ViewModifier, Decodable, TextModifier {
    /// The foreground color to use when rendering the view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var color: SwiftUI.Color

    func body(content: Content) -> some View {
        content.foregroundColor(color)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.foregroundColor(color)
    }
}
