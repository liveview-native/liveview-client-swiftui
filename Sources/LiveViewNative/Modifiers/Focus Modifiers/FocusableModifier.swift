//
//  FocusableModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/18/2023.
//

import SwiftUI

/// Sets whether an element can receive focus.
///
/// You can apply this modifier to elements that do not receive focus by default.
///
/// ```html
/// <Rectangle modifiers={focusable([])} />
/// ```
///
/// Or disable focusability for an element.
/// ```html
/// <Button modifiers={focusable(false)}>
///     Click Me
/// </Button>
/// ```
///
/// ## Arguments
/// * ``focusable``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct FocusableModifier: ViewModifier, Decodable {
    /// Sets whether the element can receive focus. Defaults to true.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let isFocusable: Bool

    func body(content: Content) -> some View {
        content
            #if !os(iOS)
            .focusable(isFocusable)
            #endif
    }
}
