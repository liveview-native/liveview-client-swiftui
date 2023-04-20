//
//  AnyShapeStyle.swift
// LiveViewNative
//
//  Created by May Matyi on 3/1/23.
//

import SwiftUI

/// A color, gradient, or other style.
///
/// Create a shape style with a type, options, and modifiers.
///
/// ```elixir
/// {:color, :blue}
/// {:color, :red, [{:opacity, 0.5}]}
/// ```
///
/// ## Shape Styles
///
/// ### :color
/// See ``LiveViewNative/SwiftUI/Color/init(from:)`` for a list of possible color values.
///
/// ### :linear_gradient
/// See ``LiveViewNative/SwiftUI/LinearGradient`` for details on creating this style.
///
/// ### :hierarchical
/// See ``LiveViewNative/SwiftUI/HierarchicalShapeStyle`` for details on creating this style.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension AnyShapeStyle: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let color = try? container.decode(SwiftUI.Color?.self, forKey: .style) {
            self = Self(color)
        } else if let linearGradient = try? container.decode(LinearGradient?.self, forKey: .style) {
            self = Self(linearGradient)
        } else if let hierarchical = try? container.decode(HierarchicalShapeStyle.self, forKey: .style) {
            self = Self(hierarchical)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for AnyShapeStyle"))
        }
    }
    enum CodingKeys: String, CodingKey {
        case style
    }
}
