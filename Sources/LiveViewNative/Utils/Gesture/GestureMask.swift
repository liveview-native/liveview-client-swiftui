//
//  GestureMask.swift
//  
//
//  Created by Carson Katri on 4/20/23.
//

import SwiftUI

/// Configures how a ``GestureModifier`` modifier impacts other gestures on an element.
///
/// Possible values:
/// * `none` - Disables the added gesture and all gestures on child elements.
/// * `gesture` - Enables the added gesture and ignores gestures on child elements.
/// * `subviews` - Enables gestures on child elements and ignores the added gesture.
/// * `all` - Enables the added gesture and all existing gestures.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension GestureMask: Decodable {
    public init(from decoder: Decoder) throws {
        if let singleValue = try? decoder.singleValueContainer() {
            switch try singleValue.decode(String.self) {
            case "none": self = .none
            case "gesture": self = .gesture
            case "subviews": self = .subviews
            case "all": self = .all
            case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: singleValue.codingPath, debugDescription: "unknown GestureMask '\(`default`)'"))
            }
        } else {
            var unkeyed = try decoder.unkeyedContainer()
            var result = Self()
            while !unkeyed.isAtEnd {
                result = result.union(try unkeyed.decode(Self.self))
            }
            self = result
        }
    }
}
