//
//  ScrollContentBackgroundModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/27/23.
//

import SwiftUI

/// Specifies the visibility of the background for scrollable views within this view.
///
/// ```html
/// <List modifiers={scroll_content_background(:hidden)}>
///     <Text>One</Text>
///     <Text>Two</Text>
///     <Text>Three</Text>
/// </List>
/// ```
///
/// ## Arguments
/// * ``visibility``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
struct ScrollContentBackgroundModifier: ViewModifier, Decodable {
    /// The visibility to use for the background.
    ///
    /// Possible values:
    /// * `automatic`
    /// * `visible`
    /// * `hidden`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let visibility: Visibility
    
    func body(content: Content) -> some View {
        content
            #if !os(tvOS)
            .scrollContentBackground(visibility)
            #endif
    }
}
