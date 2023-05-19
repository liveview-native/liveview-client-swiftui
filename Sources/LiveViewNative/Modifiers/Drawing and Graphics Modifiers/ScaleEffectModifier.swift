//
//  ScaleEffectModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/19/23.
//

import SwiftUI

/// Scales this view’s rendered output by the given vertical and horizontal size amounts, relative to an anchor point.
///
/// ```html
/// <Text modifiers={scale_effect(@native, scale: [0.5, 0.5], anchor: :bottom)}>
///     Scale by a width and height factor
/// </Text>
/// ```
///
/// ## Arguments
/// * ``scale``
/// * ``anchor``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ScaleEffectModifier: ViewModifier, Decodable {
    /// The horizontal and vertical amount to scale the view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let scale: CGSize

    /// The ``LiveViewNative/SwiftUI/UnitPoint`` from which to apply the transformation`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let anchor: UnitPoint

    func body(content: Content) -> some View {
        content.scaleEffect(scale, anchor: anchor)
    }
}
