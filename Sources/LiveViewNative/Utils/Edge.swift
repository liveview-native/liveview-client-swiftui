//
//  Edge.swift
//  
//
//  Created by Carson Katri on 4/5/23.
//

import SwiftUI

/// A value that represents a side.
///
/// Possible values:
/// * `top`
/// * `leading`
/// * `bottom`
/// * `trailing`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Edge: Decodable {
    public init(from decoder: Decoder) throws {
        switch try decoder.singleValueContainer().decode(String.self) {
        case "top": self = .top
        case "leading": self = .leading
        case "bottom": self = .bottom
        case "trailing": self = .trailing
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown edge '\(`default`)'"))
        }
    }
}

/// A value that represents a set of sides.
///
/// Possible values:
/// * `all`
/// * `horizontal`
/// * `vertical`
/// * `top`
/// * `leading`
/// * `bottom`
/// * `trailing`
/// * An array of these values
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Edge.Set: Decodable {
    public init(from decoder: Decoder) throws {
        if var container = try? decoder.unkeyedContainer() {
            var result = Self()
            while !container.isAtEnd {
                result.insert(try container.decode(Edge.Set.self))
            }
            self = result
        } else {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "all":
                self = .all
            case "horizontal":
                self = .horizontal
            case "vertical":
                self = .vertical
            default:
                self = [.init(try container.decode(Edge.self))]
            }
        }
    }
}
