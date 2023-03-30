//
//  ToolbarPlacement.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/30/2023.
//

import SwiftUI

extension ToolbarPlacement: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "automatic": self = .automatic
        #if os(iOS)
        case "bottom_bar": self = .bottomBar
        #endif
        #if !os(macOS)
        case "navigation_bar": self = .navigationBar
        #endif
        #if os(iOS) || os(tvOS)
        case "tab_bar": self = .tabBar
        #endif
        #if os(macOS)
        case "window_toolbar": self = .windowToolbar
        #endif
        default: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for ToolbarPlacement"))
        }
    }
}
