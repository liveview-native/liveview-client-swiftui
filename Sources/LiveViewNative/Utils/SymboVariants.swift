//
//  SymboVariants.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 5/30/23.
//

import SwiftUI

/// A variant of a symbol.
///
/// Possible values:
/// * `none`
/// * `circle`
/// * `square`
/// * `rectangle`
/// * `fill`
/// * `slash`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension SymbolVariants: Decodable {
    public init(from decoder: Decoder) throws {
        switch try decoder.singleValueContainer().decode(String.self) {
        case "none": self = .none
        case "circle": self = .circle
        case "square": self = .square
        case "rectangle": self = .rectangle
        case "fill": self = .fill
        case "slash": self = .slash
        case let `default`:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "unknown blend mode '\(`default`)'"))
        }
    }
}
