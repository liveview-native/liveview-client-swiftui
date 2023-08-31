//
//  ScrollDismissesKeyboardModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/28/23.
//

import SwiftUI

/// Configures the behavior in which scrollable content interacts with the software keyboard.
///
/// ```html
/// <List modifiers={scroll_dismisses_keyboard(:never)}>
///     <Text>One</Text>
///     <Text>Two</Text>
///     <Text>Three</Text>
///     ...
/// </List>
/// ```
///
/// ## Arguments
/// * ``mode``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
struct ScrollDismissesKeyboardModifier: ViewModifier, Decodable {
    /// The keyboard dismissal mode that scrollable content uses.
    ///
    /// See ``LiveViewNative/SwiftUI/ScrollDismissesKeyboardMode`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let mode: ScrollDismissesKeyboardMode
    
    func body(content: Content) -> some View {
        content.scrollDismissesKeyboard(mode)
    }
}
