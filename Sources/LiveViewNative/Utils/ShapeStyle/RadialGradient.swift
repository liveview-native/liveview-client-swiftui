//
//  EllipticalGradient.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/25/23.
//
import SwiftUI

/// A shape style that draws a gradient in a circle.
///
/// To create this shape style, create a map or keyword list with the `gradient` key set to a ``LiveViewNative/SwiftUI/Gradient`` value,
/// and the `start_radius` and `end_radius` set to float values.
///
/// ```elixir
/// [gradient: {:colors, [:pink, :blue]}, start_radius: 0, end_radius: 100]
/// ```
/// 
/// Set the `center` argument to a ``LiveViewNative/SwiftUI/UnitPoint`` value to offset the origin of the ellipse.
///
/// ```elixir
/// [gradient: {:colors, [:pink, :blue]}, start_radius: 0, end_radius: 100, center: {0, 0}]
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension RadialGradient: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            gradient: try container.decode(Gradient.self, forKey: .gradient),
            center: try container.decode(UnitPoint.self, forKey: .center),
            startRadius: try container.decode(CGFloat.self, forKey: .startRadius),
            endRadius: try container.decode(CGFloat.self, forKey: .endRadius)
        )
    }

    enum CodingKeys: String, CodingKey {
        case gradient
        case center
        case startRadius = "start_radius"
        case endRadius = "end_radius"
    }
}
