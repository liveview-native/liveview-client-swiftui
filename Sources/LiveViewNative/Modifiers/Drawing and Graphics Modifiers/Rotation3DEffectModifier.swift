//
//  Rotation3DEffectModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/6/2023.
//

import SwiftUI

/// Applies a 3D rotation effect to the element.
///
/// Provide the ``angle`` and ``axis`` to rotate around to create the modifier.
///
/// ```html
/// <Text modifiers={rotation_3d_effect({:degrees, 45}, axis: {0, 1, 0})}>
///     Rotation by passing an angle in degrees
/// </Text>
/// ```
///
/// The above example will rotate the text 45º around the Y axis.
///
/// ## Arguments
/// * ``angle``
/// * ``axis``
/// * ``anchor``
/// * [`anchor_z`](doc:Rotation3DEffectModifier/anchorZ)
/// * ``perspective``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Rotation3DEffectModifier: ViewModifier, Decodable {
    /// The angle in radians or degrees to rotate.
    ///
    /// See ``LiveViewNative/SwiftUI/Angle`` for more details on creating angles.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let angle: Angle
    
    /// The axis to rotate around.
    ///
    /// Use a 3-element tuple to specify the axis.
    ///
    /// ```elixir
    /// {x, y, z}
    /// {1, 0, 0} # X-axis rotation
    /// {0, 1, 0.5} # Y and half Z axis rotation.
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let axis: (x: CGFloat, y: CGFloat, z: CGFloat)

    /// The ``LiveViewNative/SwiftUI/UnitPoint`` to center the rotation around. Defaults to `{0.5, 0.5}`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let anchor: UnitPoint

    /// `anchor_z`, the 3D position of the ``anchor``. Defaults to `0`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let anchorZ: CGFloat

    /// The relative vanishing point. Defaults to `1`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let perspective: CGFloat

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.angle = .radians(try container.decode(Double.self, forKey: .angle))
        
        let axisContainer = try container.nestedContainer(keyedBy: CodingKeys.Axis.self, forKey: .axis)
        self.axis = (
            x: try axisContainer.decode(CGFloat.self, forKey: .x),
            y: try axisContainer.decode(CGFloat.self, forKey: .y),
            z: try axisContainer.decode(CGFloat.self, forKey: .z)
        )

        self.anchor = try container.decodeIfPresent(UnitPoint.self, forKey: .anchor) ?? .center
        self.anchorZ = try container.decode(Double.self, forKey: .anchorZ)
        self.perspective = try container.decode(Double.self, forKey: .perspective)
    }

    func body(content: Content) -> some View {
        content.rotation3DEffect(angle, axis: axis, anchor: anchor, anchorZ: anchorZ, perspective: perspective)
    }

    enum CodingKeys: String, CodingKey {
        case angle
        case axis
        case anchor
        case anchorZ
        case perspective
        
        enum Axis: String, CodingKey {
            case x, y, z
        }
    }
}
