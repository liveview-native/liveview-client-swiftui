//
//  LinearGradient.swift
// LiveViewNative
//
//  Created by Carson Katri on 4/21/23.
//
import SwiftUI

/// A shape style that creates a conic gradient.
///
/// To create this shape style, create a map or keyword list with the `gradient` key set to a ``LiveViewNative/SwiftUI/Gradient`` value.
/// 
/// Specify an `angle` to create a full rotation with an offset.
/// Provide a `start_angle` and `end_angle` to describe a partial rotation.
///
/// ```elixir
/// [gradient: {:colors, [:pink, :blue, 0.9]}, angle: {:degrees, 45}]
/// [gradient: {:colors, [:pink, :blue, 0.9]}, start_angle: {:degrees, 45}, end_angle: {:degrees, 90}]
/// ```
/// 
/// See ``LiveViewNative/SwiftUI/Angle`` for more details on creating angles.
/// 
/// Set the `center` argument to a ``LiveViewNative/SwiftUI/UnitPoint`` value to offset the origin of the rotation.
///
/// ```elixir
/// [gradient: {:stops, [{:pink, 0.8}, {:blue, 0.9}]}, angle: {:degrees, 45}, center: {0, 0}]
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension AngularGradient: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gradient = try container.decode(Gradient.self, forKey: .gradient)
        let center = try container.decode(UnitPoint.self, forKey: .center)
        if let angle = try container.decodeIfPresent(Angle.self, forKey: .angle) {
            self.init(gradient: gradient, center: center, angle: angle)
        } else {
            self.init(
                gradient: gradient,
                center: center,
                startAngle: try container.decode(Angle.self, forKey: .startAngle),
                endAngle: try container.decode(Angle.self, forKey: .endAngle)
            )
        }
    }

    enum CodingKeys: String, CodingKey {
        case gradient
        case center
        case angle
        case startAngle
        case endAngle
    }
}
