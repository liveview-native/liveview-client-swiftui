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
/// <Text modifiers={scale_effect(scale: [0.5, 0.5], anchor: :bottom)}>
///     Scale by a width and height factor
/// </Text>
/// ```
///
/// ## Arguments
/// * ``scale``
/// * ``x``
/// * ``y``
/// * ``anchor``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ScaleEffectModifier: ViewModifier, Decodable {
    /// The horizontal and vertical amount to scale the view.
    ///
    /// Takes precedence over ``x`` and ``y``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let scale: CGSize?
    
    /// The horizontal amount to scale.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let x: Double?
    
    /// The vertical amount to scale.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let y: Double?

    /// The ``LiveViewNative/SwiftUI/UnitPoint`` from which to apply the transformation. Defaults to `center`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let anchor: UnitPoint?

    func body(content: Content) -> some View {
        content.scaleEffect(scale ?? .init(width: x ?? 1, height: y ?? 1), anchor: anchor ?? .center)
    }
}
