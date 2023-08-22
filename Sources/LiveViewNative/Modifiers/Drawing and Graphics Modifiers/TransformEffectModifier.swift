//
//  TransformEffectModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/16/2023.
//

import SwiftUI

/// Transforms an element with a ``LiveViewNative/CoreFoundation/CGAffineTransform``.
///
/// Provide a ``LiveViewNative/CoreFoundation/CGAffineTransform`` to the ``transform`` argument to modify the element.
///
/// - Note: The frame of the element is not affected.
///
/// ```html
/// <Text modifiers={transform_effect([
///     {:translate, {50, 0}},
///     {:rotate, {:degrees, 45}},
///     {:scale, 0.5}
/// ])}>
///     Hello, world!
/// </Text>
/// ```
///
/// ## Arguments
/// * ``transform``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TransformEffectModifier: ViewModifier, Decodable {
    /// The transformation to apply.
    ///
    /// See ``LiveViewNative/CoreFoundation/CGAffineTransform`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let transform: CGAffineTransform

    func body(content: Content) -> some View {
        content.transformEffect(transform)
    }
}

