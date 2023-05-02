//
//  LinearGradient.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//
import SwiftUI

/// A shape style that creates a gradient between two points.
///
/// To create this shape style, create a map or keyword list with the `gradient` key set to a ``LiveViewNative/SwiftUI/Gradient`` value.
///
/// ```elixir
/// [gradient: {:colors, [:pink, :blue]}]
/// ```
///
/// Use the `start_point` and `end_point` keys to customize the gradient further.
///
/// ```elixir
/// [gradient: {:colors, [:pink, :blue]}, start_point: {0, 0}, end_point: {1, 1}]
/// ```
///
/// See ``LiveViewNative/SwiftUI/UnitPoint`` for more details on creating the start/end points.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension LinearGradient: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gradient: Gradient = try container.decode(Gradient.self, forKey: .gradient)
        let startPoint: UnitPoint = try container.decode(UnitPoint.self, forKey: .startPoint)
        let endPoint: UnitPoint = try container.decode(UnitPoint.self, forKey: .endPoint)

        self = LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
    }

    enum CodingKeys: String, CodingKey {
        case gradient
        case startPoint
        case endPoint
    }
}
