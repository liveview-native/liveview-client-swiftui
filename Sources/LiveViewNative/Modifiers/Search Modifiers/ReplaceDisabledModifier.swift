//
//  ReplaceDisabledModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/19/2023.
//

import SwiftUI

/// Controls whether the replace is disabled (but not find).
///
/// Use this modifier with a ``TextEditor``:
///
/// ```html
/// <TextEditor text="my_text" modifiers={replace_disabled(true)} />
/// ```
///
/// ## Arguments
/// * ``disabled``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, *)
struct ReplaceDisabledModifier: ViewModifier, Decodable {
    /// Whether the find navigator is disabled or not.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let disabled: Bool
    
    func body(content: Content) -> some View {
        content
            #if os(iOS)
            .replaceDisabled(disabled)
            #endif
    }
}
