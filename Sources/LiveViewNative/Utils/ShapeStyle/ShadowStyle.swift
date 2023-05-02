//
//  ShadowStyle.swift
//  
//
//  Created by Carson Katri on 4/25/23.
//

import SwiftUI

/// A shadow configuration.
///
/// Two types of shadow can be created, `:drop` and `:inner`. Use a tuple where the first element is the type and the second is a keyword list or map with any options.
///
/// The `radius` argument is required.
///
/// ```elixir
/// {:drop, [radius: 10]}
/// {:inner, [radius: 5]}
/// ```
///
/// Optionally, set the `color`, `x` and `y` arguments to customize the shadow.
///
/// ```elixir
/// {:drop, [color: :red, radius: 10, x: 10, y: -5]}
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension ShadowStyle: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch try container.decode(ShadowType.self, forKey: .type) {
        case .drop:
            self = .drop(
                color: try container.decodeIfPresent(SwiftUI.Color.self, forKey: .color) ?? .init(.sRGBLinear, white: 0, opacity: 0.33),
                radius: try container.decode(CGFloat.self, forKey: .radius),
                x: try container.decodeIfPresent(CGFloat.self, forKey: .x) ?? 0,
                y: try container.decodeIfPresent(CGFloat.self, forKey: .y) ?? 0
            )
        case .inner:
            self = .inner(
                color: try container.decodeIfPresent(SwiftUI.Color.self, forKey: .color) ?? .init(.sRGBLinear, white: 0, opacity: 0.55),
                radius: try container.decode(CGFloat.self, forKey: .radius),
                x: try container.decodeIfPresent(CGFloat.self, forKey: .x) ?? 0,
                y: try container.decodeIfPresent(CGFloat.self, forKey: .y) ?? 0
            )
        }
    }

    enum CodingKeys: String, CodingKey {
        case type
        case color
        case radius
        case x
        case y
    }
    
    enum ShadowType: String, Decodable {
        case drop
        case inner
    }
}
