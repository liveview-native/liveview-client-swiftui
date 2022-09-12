//
//  Alignment.swift
//  PhoenixLiveViewNative
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
#if compiler(>=5.7)
        // although these are marked as being available back to iOS 13, they were only made public in Xcode 14
        // so we only compile them if the user's Xcode version is new enough
        case "leading-last-text-baseline":
            self = .leadingLastTextBaseline
        case "trailing-last-text-baseline":
            self = .trailingLastTextBaseline
#endif
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
