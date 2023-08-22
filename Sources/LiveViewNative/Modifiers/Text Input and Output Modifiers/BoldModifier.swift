//
//  BoldModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/23/23.
//

import SwiftUI

/// Makes any child ``Text`` elements bold.
///
/// The effect can be toggled with the [`is_active`](doc:BoldModifier/isActive) argument.
///
/// ```html
/// <Text modifiers={bold([])}>Hello, world!</Text>
/// <Text modifiers={bold(false)}>Hello, world!</Text>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct BoldModifier: ViewModifier, Decodable, TextModifier {
    /// Enables/disables the bold effect.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var isActive: Bool
    
    func body(content: Content) -> some View {
        content.bold(isActive)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.bold(isActive)
    }
}
