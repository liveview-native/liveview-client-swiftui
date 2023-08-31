//
//  ProjectionEffectModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/23/2023.
//

import SwiftUI

/// Applies a 3D transformation matrix to an element.
///
/// Create a ``LiveViewNative/SwiftUI/ProjectionTransform`` to tweak the visual display of the element.
///
/// - Note: The frame of the element is not affected.
///
/// ```html
/// <Text modifiers={projection_effect([
///     {:translate, {50, 0, 10}},
///     {:rotate, {:degrees, 45}, {0, 0, 1}},
///     {:scale, 0.5}
/// ])}>
///     Hello, world!
/// </Text>
/// ```
///
/// - Note: watchOS does not support 3D transformations.
/// The input values will be treated as a 3x3 matrix, and other values will be ignored.
///
/// ## Arguments
/// * ``transform``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ProjectionEffectModifier: ViewModifier, Decodable {
    /// The 4x4 transformation matrix to apply.
    ///
    /// See ``LiveViewNative/SwiftUI/ProjectionTransform`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let transform: ProjectionTransform

    func body(content: Content) -> some View {
        content.projectionEffect(transform)
    }
}
