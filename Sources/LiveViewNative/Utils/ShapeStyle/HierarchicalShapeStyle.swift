//
//  HierarchicalShapeStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/20/23.
//
import SwiftUI

/// A shape style that maps to a numbered content style.
///
/// Possible values:
/// * `primary`
/// * `secondary`
/// * `tertiary`
/// * `quaternary`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension HierarchicalShapeStyle: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "primary": self = .primary
        case "secondary": self = .secondary
        case "tertiary": self = .tertiary
        case "quaternary": self = .quaternary
        case let `default`:
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "unknown hierarchical style '\(`default`)'"))
        }
    }
}
