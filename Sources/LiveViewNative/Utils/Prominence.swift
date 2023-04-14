//
//  Prominence.swift
//  
//
//  Created by Carson Katri on 4/13/23.
//

import SwiftUI

/// A value that indicates the prominence of an element.
///
/// Possible values:
/// * `standard`
/// * `increased`
extension Prominence: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "standard": self = .standard
        case "increased": self = .increased
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown Prominence '\(`default`)'"))
        }
    }
}
