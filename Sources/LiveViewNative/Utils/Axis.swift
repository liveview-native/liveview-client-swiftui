//
//  Axis.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

extension Axis.Set: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let alignment = Self(string: string) {
            self = alignment
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for HorizontalAlignment"))
        }
    }
    
    init?(string: String) {
        switch string {
        case "horizontal":
            self = .horizontal
        case "vertical":
            self = .vertical
        case "all":
            self = [.horizontal, .vertical]
        default:
            return nil
        }
    }
}
