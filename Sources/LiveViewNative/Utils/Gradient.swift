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
        var gradient: Gradient = Gradient(colors: [])

        if let createWith = try container.decode(String?.self, forKey: .createWith) {
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
                // TODO: Fix this
                gradient = Gradient(colors: [])
            }
        }
        self = gradient
    }
    
    enum CodingKeys: String, CodingKey {
        case colors
        case createWith = "create_with"
        case stops
    }
}
