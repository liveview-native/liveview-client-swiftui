//
//  GridItem.swift
//  
//
//  Created by Carson Katri on 2/15/23.
//

import SwiftUI

/// A configuration item for ``LazyVGrid`` and ``LazyHGrid``.
///
/// Provide a `size`, and optional `spacing`/`alignment` values.
///
/// ```
/// %{ size: %{ fixed: 30 } }
/// %{ size: :flexible, spacing: 1, alignment: :topLeading }
/// %{ size: %{ flexible: %{ minimum: 0, maximum: 100 } }, spacing: 1, alignment: :topLeading }
/// %{ size: %{ adaptive: %{ minimum: 10 } } }
/// ```
extension GridItem: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            try container.decode(Size.self, forKey: .size),
            spacing: try container.decodeIfPresent(CGFloat.self, forKey: .spacing),
            alignment: try container.decodeIfPresent(Alignment.self, forKey: .alignment)
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case size
        case spacing
        case alignment
    }
}

/// The size of a ``GridItem``.
///
/// Supported values:
/// * `%{ fixed: <value> }`
/// * `:flexible`
/// * `%{ flexible: %{ minimum: <optional value>, maximum: <optional value> } }`
/// * `%{ adaptive: %{ minimum: <value>, maximum: <optional value> } }`
extension GridItem.Size: Decodable {
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            if container.contains(.fixed) {
                self = .fixed(try container.decode(Double.self, forKey: .fixed))
            } else if container.contains(.flexible) {
                let nested = try container.nestedContainer(keyedBy: BoundsKeys.self, forKey: .flexible)
                self = .flexible(
                    minimum: try nested.decodeIfPresent(Double.self, forKey: .minimum) ?? 10,
                    maximum: try nested.decodeIfPresent(Double.self, forKey: .maximum) ?? .infinity
                )
            } else {
                let nested = try container.nestedContainer(keyedBy: BoundsKeys.self, forKey: .adaptive)
                self = .adaptive(
                    minimum: try nested.decode(Double.self, forKey: .minimum),
                    maximum: try nested.decodeIfPresent(Double.self, forKey: .maximum) ?? .infinity
                )
            }
        } else {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "flexible":
                self = .flexible()
            case let fallback:
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown size \(fallback)"))
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case fixed
        case flexible
        case adaptive
    }
    
    enum BoundsKeys: String, CodingKey {
        case minimum
        case maximum
    }
}
