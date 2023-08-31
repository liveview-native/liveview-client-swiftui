//
//  RotationModifier.swift
//
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

/// Rotates a ``Shape``.
///
/// Pass an ``LiveViewNative/SwiftUI/Angle`` to rotate by.
///
/// ```html
/// <Circle modifiers={rotation({:degrees, 10})} />
/// ```
///
/// ## Arguments
/// * ``angle``
/// * ``anchor``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct RotationModifier: ShapeModifier, Decodable {
    /// The amount to rotate by.
    ///
    /// See ``LiveViewNative/SwiftUI/Angle`` for more details on creating angles.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let angle: Angle
    
    /// The origin of the rotation. Defaults to `center`.
    ///
    /// See ``LiveViewNative/SwiftUI/UnitPoint`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let anchor: UnitPoint?
    
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
        shape.rotation(angle, anchor: anchor ?? .center)
    }
    
    func apply(to shape: some SwiftUI.InsettableShape) -> any SwiftUI.Shape {
        shape.rotation(angle, anchor: anchor ?? .center)
    }
}
