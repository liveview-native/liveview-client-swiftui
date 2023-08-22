//
//  RotationEffectModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/6/2023.
//

import SwiftUI

/// Applies a rotation effect to the element.
///
/// Pass an ``angle`` in degrees or radians to rotate the element.
///
/// ```html
/// <Text modifiers={rotation_effect({:degrees, 22})}>
///     Rotation by passing an angle in degrees
/// </Text>
/// ```
///
/// ## Arguments
/// * ``angle``
/// * ``anchor``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct RotationEffectModifier: ViewModifier, Decodable {
    /// The angle in radians or degrees to rotate.
    ///
    /// See ``LiveViewNative/SwiftUI/Angle`` for more details on creating angles.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let angle: Angle

    /// The ``LiveViewNative/SwiftUI/UnitPoint`` to center the rotation around. Defaults to `{0.5, 0.5}`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let anchor: UnitPoint

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.angle = try container.decode(Angle.self, forKey: .angle)
        self.anchor = try container.decodeIfPresent(UnitPoint.self, forKey: .anchor) ?? .center
    }

    func body(content: Content) -> some View {
        content.rotationEffect(angle, anchor: anchor)
    }

    enum CodingKeys: String, CodingKey {
        case angle
        case anchor
    }
}
