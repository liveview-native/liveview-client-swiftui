//
//  ListItemTint.swift
//  
//
//  Created by Carson Katri on 4/13/23.
//

import SwiftUI

/// A tint for a list row.
///
/// Possible values:
/// * `:monochrome` - A single-color type
/// * `{:fixed, color}` - Forces the tint to be the provided color
/// * `{:preferred, color}` - Respects the system accent color if set, otherwise it uses the provided color
extension ListItemTint: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .type) {
        case "monochrome":
            self = .monochrome
        case "fixed":
            self = .fixed(try container.decode(SwiftUI.Color.self, forKey: .color))
        case "preferred":
            self = .preferred(try container.decode(SwiftUI.Color.self, forKey: .color))
        case let `default`:
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown ListItemTint type '\(`default`)'"))
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case color
    }
}
