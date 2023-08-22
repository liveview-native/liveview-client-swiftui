//
//  ShadowModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/24/23.
//

import SwiftUI

/// Adds a shadow to this view.
///
/// ```html
/// <Text modifiers={shadow(color: :gray, radius: 2, x: 2, y: 2)}>Shadowed Text</Text>
/// ```
///
/// ## Arguments
/// * ``color``
/// * ``radius``
/// * ``x``
/// * ``y``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ShadowModifier: ViewModifier, Decodable {
    /// The shadow’s color.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let color: SwiftUI.Color
    
    /// A measure of how much to blur the shadow. Larger values result in more blur.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let radius: CGFloat

    /// An amount to offset the shadow horizontally from the view. Defaults to 0.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let x: CGFloat

    /// An amount to offset the shadow vertically from the view. Defaults to 0.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let y: CGFloat
    
    func body(content: Content) -> some View {
        content.shadow(color: color, radius: radius, x: x, y: y)
    }
}
