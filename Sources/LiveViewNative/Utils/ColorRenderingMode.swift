//
//  ColorRenderingMode.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 5/17/23.
//

import SwiftUI

/// One of the working color space and storage formats.
///
/// Possible values:
/// * `extended_linear`
/// * `linear`
/// * `non_linear`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension ColorRenderingMode: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value {
        case "extended_linear": self = .extendedLinear
        case "linear": self = .linear
        case "non_linear": self = .nonLinear
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown \(String(describing: decoder.codingPath.last)): \(value)"))
        }
    }
}
