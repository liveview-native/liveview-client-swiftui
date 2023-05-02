//
//  Material.swift
//  
//
//  Created by Carson Katri on 4/20/23.
//

import SwiftUI

#if os(iOS) || os(macOS)
/// A translucent shape style.
///
/// Use material to create blur effects.
///
/// Possible values:
/// * `ultra_thin`
/// * `thin`
/// * `regular`
/// * `thick`
/// * `ultra_thick`
/// * `bar` (only available on iOS and macOS)
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Material: Decodable {
    public init(from decoder: Decoder) throws {
        switch try decoder.singleValueContainer().decode(String.self) {
        case "ultra_thin":
            self = .ultraThin
        case "thin":
            self = .thin
        case "regular":
            self = .regular
        case "thick":
            self = .thick
        case "ultra_thick":
            self = .ultraThick
        case "bar":
            self = .bar
        case let `default`:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "unknown material '\(`default`)'"))
        }
    }
}
#endif
