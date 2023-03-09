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
        var gradient: Gradient?

        if let colors = try container.decodeIfPresent([SwiftUI.Color]?.self, forKey: .colors) {
            gradient = Gradient(colors: colors!)
        } else if let stops = try container.decodeIfPresent([Gradient.Stop]?.self, forKey: .stops) {
            gradient = Gradient(stops: stops!)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected either colors or stops for Gradient"))
        }

        self = gradient!
    }

    enum CodingKeys: String, CodingKey {
        case colors
        case stops
    }
}
