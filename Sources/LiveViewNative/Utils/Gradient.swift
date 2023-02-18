//
//  Gradient.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//

import SwiftUI

extension Gradient: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let createWith = try container.decode(String?.self, forKey: .createWith)
        var gradient: Gradient?

        switch createWith {
            case "colors":
                if let colors = try container.decode([Color]?.self, forKey: .colors) {
                    gradient = Gradient(colors: colors)
                }

            case "stops":
                if let stops = try container.decode([Gradient.Stop]?.self, forKey: .stops) {
                    gradient = Gradient(stops: stops)
                }

            default:
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for createWith"))
        }
        self = gradient!
    }
    
    enum CodingKeys: String, CodingKey {
        case colors
        case createWith = "create_with"
        case stops
    }
}
