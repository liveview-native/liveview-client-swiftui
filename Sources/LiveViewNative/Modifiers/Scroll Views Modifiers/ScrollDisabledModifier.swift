//
//  ScrollDisabledModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/27/23.
//

import SwiftUI

/// Disables or enables scrolling in scrollable views.
///
/// ```html
/// <List modifiers={scroll_disabled(true)}>
///     <Text>One</Text>
///     <Text>Two</Text>
///     <Text>Three</Text>
/// </List>
/// ```
///
/// ## Arguments
/// * ``disabled``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ScrollDisabledModifier: ViewModifier, Decodable {
    /// Indicates whether scrolling is disabled.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let disabled: Bool
    
    func body(content: Content) -> some View {
        content.scrollDisabled(disabled)
    }
}
