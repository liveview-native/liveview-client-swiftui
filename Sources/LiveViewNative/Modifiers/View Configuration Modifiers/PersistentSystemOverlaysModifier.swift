//
//  PersistentSystemOverlaysModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/23/2023.
//

import SwiftUI

/// Set the visibility of system overlays such as the Home indicator, Multi-task indicator, etc.
///
/// - Note: This sets a preference, which the system may ignore.
///
/// ```html
/// <Text modifiers={persistent_system_overlays(:hidden)}>
///   Immersive Content
/// </Text>
/// ```
///
/// ## Arguments
/// * ``visibility``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct PersistentSystemOverlaysModifier: ViewModifier, Decodable {
    /// The visibility of system overlays.
    ///
    /// See ``LiveViewNative/SwiftUI/Visibility`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let visibility: Visibility

    func body(content: Content) -> some View {
        content.persistentSystemOverlays(visibility)
    }
}

