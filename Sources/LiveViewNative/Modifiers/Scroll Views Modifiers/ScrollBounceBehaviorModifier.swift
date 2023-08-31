//
//  ScrollBounceBehaviorModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/28/23.
//

import SwiftUI

/// Configures the bounce behavior of scrollable views along the specified axis.
///
/// ```html
/// <List modifiers={scroll_bounce_behavior(:always, axes: :all)}>
///     <Text>One</Text>
///     <Text>Two</Text>
///     <Text>Three</Text>
///     ...
/// </List>
/// ```
///
/// ## Arguments
/// * ``behavior``
/// * ``axes``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
struct ScrollBounceBehaviorModifier: ViewModifier, Decodable {
    /// The bounce behavior to apply to any scrollable views within the configured view.
    ///
    /// See ``LiveViewNative/SwiftUI/ScrollBounceBehavior`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let behavior: ScrollBounceBehavior
    
    /// The set of axes to apply behavior to.. Defaults to `vertical`.
    ///
    /// See ``LiveViewNative/SwiftUI/Axis/Set`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let axes: Axis.Set
    
    func body(content: Content) -> some View {
        content.scrollBounceBehavior(behavior, axes: axes)
    }
}
