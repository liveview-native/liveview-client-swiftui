//
//  Alignment.swift
// LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

extension Alignment {
    init?(string: String) {
        switch string {
        case "top-leading":
            self = .topLeading
        case "top":
            self = .top
        case "top-trailing":
            self = .topTrailing
        case "leading":
            self = .leading
        case "center":
            self = .center
        case "trailing":
            self = .trailing
        case "bottom-leading":
            self = .bottomTrailing
        case "bottom":
            self = .bottom
        case "bottom-trailing":
            self = .bottomTrailing
        case "leading-last-text-baseline":
            self = .leadingLastTextBaseline
        case "trailing-last-text-baseline":
            self = .trailingLastTextBaseline
        default:
            return nil
        }
    }
}

extension Alignment: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let alignment = Self(string: string) {
            self = alignment
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for Alignment"))
        }
    }
}
