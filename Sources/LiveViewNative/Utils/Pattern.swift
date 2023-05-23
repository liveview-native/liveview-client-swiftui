//
//  Pattern.swift
//  
//
//  Created by Carson Katri on 5/23/23.
//

import SwiftUI

/// The pattern to use for a line.
///
/// Possible values:
/// * `dash`
/// * `dash_dot`
/// * `dash_dot_dot`
/// * `dot`
/// * `solid`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension SwiftUI.Text.LineStyle.Pattern: Decodable {
    public init(from decoder: Decoder) throws {
        switch try decoder.singleValueContainer().decode(String.self) {
        case "solid": self = .solid
        case "dot": self = .dot
        case "dash": self = .dash
        case "dash_dot": self = .dashDot
        case "dash_dot_dot": self = .dashDotDot
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "unknown pattern '\(`default`)'"))
        }
    }
}
