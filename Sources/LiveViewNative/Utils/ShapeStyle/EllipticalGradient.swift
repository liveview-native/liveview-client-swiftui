//
//  EllipticalGradient.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/25/23.
//
import SwiftUI

/// A shape style that draws a gradient in an ellipse.
///
/// To create this shape style, create a map or keyword list with the `gradient` key set to a ``LiveViewNative/SwiftUI/Gradient`` value.
/// 
/// Specify an `start_radius_fraction` and `end_radius_fraction` to customize the ellipse.
///
/// ```elixir
/// [gradient: {:colors, [:pink, :blue]}]
/// [gradient: {:colors, [:pink, :blue]}, start_radius_fraction: 0.5, end_radius_fraction: 1.0]
/// ```
/// 
/// Set the `center` argument to a ``LiveViewNative/SwiftUI/UnitPoint`` value to offset the origin of the ellipse.
///
/// ```elixir
/// [gradient: {:colors, [:pink, :blue]}, center: {0, 0}]
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension EllipticalGradient: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            gradient: try container.decode(Gradient.self, forKey: .gradient),
            center: try container.decode(UnitPoint.self, forKey: .center),
            startRadiusFraction: try container.decode(CGFloat.self, forKey: .startRadiusFraction),
            endRadiusFraction: try container.decode(CGFloat.self, forKey: .endRadiusFraction)
        )
    }

    enum CodingKeys: String, CodingKey {
        case gradient
        case center
        case startRadiusFraction = "start_radius_fraction"
        case endRadiusFraction = "end_radius_fraction"
    }
}
