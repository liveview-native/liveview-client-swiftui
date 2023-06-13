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
/// * An array of these values
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension SymbolVariants: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        switch try container.decode(String.self) {
        case "none": self = .none
        case "circle": self = .circle
        case "square": self = .square
        case "rectangle": self = .rectangle
        case "fill": self = .fill
        case "slash": self = .slash
        case let `default`:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "unknown blend mode '\(`default`)'"))
        }
        while !container.isAtEnd {
            switch try container.decode(String.self) {
            case "circle": self = self.circle
            case "square": self = self.square
            case "rectangle": self = self.rectangle
            case "fill": self = self.fill
            case "slash": self = self.slash
            case let `default`:
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "unknown blend mode '\(`default`)'"))
            }
        }
    }
}
