//
//  PresentationDetent.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/28/23.
//

import SwiftUI

/// A type that indicates where on-screen a sheet can snap to.
///
/// The following values are supported:
/// - `:large` - the system-defined large detent
/// - `:medium` - the system-defined medium detent
/// - `{:fraction, value}` - a fraction of the available height. The value should be between 0 and 1.
/// - `{:height, value}` - a fixed height
extension PresentationDetent: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "large":
            self = .large
        case "medium":
            self = .medium
        case "fraction":
            self = .fraction(try container.decode(CGFloat.self, forKey: .value))
        case "height":
            self = .height(try container.decode(CGFloat.self, forKey: .value))
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type for PresentationDetent")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }
}
