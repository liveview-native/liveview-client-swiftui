//
//  PositionModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/13/2023.
//

import SwiftUI

/// Sets an absolute position for the element.
///
/// The center of the element is placed at the provided ``x`` and ``y`` coordinates in its parent's coordinate space.
///
/// ```html
/// <Text modifiers={position(x: 100, y: 50)}>
///     Hello, world!
/// </Text>
/// ```
///
/// ## Arguments
/// * ``x``
/// * ``y``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct PositionModifier: ViewModifier, Decodable {
    /// The parent-relative horizontal position of the element.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let x: CGFloat

    /// The parent-relative vertical position of the element.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let y: CGFloat

    func body(content: Content) -> some View {
        content.position(x: x, y: y)
    }
}

