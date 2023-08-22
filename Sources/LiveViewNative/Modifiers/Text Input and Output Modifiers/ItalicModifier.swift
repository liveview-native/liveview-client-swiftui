//
//  ItalicModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/23/23.
//

import SwiftUI

/// Makes any child ``Text`` elements italic.
///
/// The effect can be toggled with the [`is_active`](doc:ItalicModifier/isActive) argument.
///
/// ```html
/// <Text modifiers={italic([])}>Hello, world!</Text>
/// <Text modifiers={italic(false)}>Hello, world!</Text>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ItalicModifier: ViewModifier, Decodable, TextModifier {
    /// Enables/disables the italic effect.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var isActive: Bool
    
    func body(content: Content) -> some View {
        content.italic(isActive)
    }
    
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text.italic(isActive)
    }
}
