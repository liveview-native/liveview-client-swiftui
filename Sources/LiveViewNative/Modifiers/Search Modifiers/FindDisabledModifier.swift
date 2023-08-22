//
//  FindDisabledModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/19/2023.
//

import SwiftUI

/// Controls whether the find navigator is disabled.
///
/// Use this modifier with a ``TextEditor``:
///
/// ```html
/// <TextEditor text="my_text" modifiers={find_disabled(true)} />
/// ```
///
/// ## Arguments
/// * ``disabled``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, *)
struct FindDisabledModifier: ViewModifier, Decodable {
    /// Whether the find navigator is disabled or not.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let disabled: Bool
    
    func body(content: Content) -> some View {
        content
            #if os(iOS)
            .findDisabled(disabled)
            #endif
    }
}
