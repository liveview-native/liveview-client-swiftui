//
//  CoordinateSpace.swift
//  
//
//  Created by Carson Katri on 4/20/23.
//

import SwiftUI

/// A named coordinate space for resolving locations.
///
/// Possible values:
/// * `global`
/// * `local`
/// * custom named coordinate space
///
/// Create a named coordinate space with the ``CoordinateSpaceModifier`` modifier.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension CoordinateSpace: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "global": self = .global
        case "local": self = .local
        case let custom:
            self = .named(custom)
        }
    }
}
