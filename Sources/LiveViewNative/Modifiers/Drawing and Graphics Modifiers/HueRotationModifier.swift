//
//  HueRotationModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/6/2023.
//

import SwiftUI

/// Applies a hue rotation effect to the element.
///
/// The hue will be rotated by the ``angle``, specified in degrees or radians.
///
/// ```html
/// <HStack>
///     <%= for item <- 0..5 do %>
///         <Rectangle
///             id={Integer.to_string(item)}
///             modifiers={
///                 @native
///                     |> foreground_style(primary: {:linear_gradient, %{ :gradient => {:colors, [:blue, :red, :green]}, :start_point => {0.5, 0}, :end_point => {0.5, 1} }})
///                     |> hue_rotation(angle: {:degrees, item * 36})
///                     |> frame(width: 60, height: 60, alignment: :center)
///             }
///         />
///     <% end %>
/// </HStack>
/// ```
///
/// ## Arguments
/// * ``angle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct HueRotationModifier: ViewModifier, Decodable {
    /// The angle in radians or degrees to rotate.
    ///
    /// See ``LiveViewNative/SwiftUI/Angle`` for more details on creating angles.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let angle: Angle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.angle = try container.decode(Angle.self, forKey: .angle)
    }

    func body(content: Content) -> some View {
        content.hueRotation(angle)
    }

    enum CodingKeys: String, CodingKey {
        case angle
    }
}
