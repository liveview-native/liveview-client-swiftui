//
//  ToolbarRole.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/30/2023.
//

import SwiftUI

/// The role of a toolbar.
///
/// Possible values:
/// * `automatic`
/// * `browser`
/// * `editor`
/// * `navigation_stack`
extension ToolbarRole: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "automatic": self = .automatic
        #if os(iOS)
        case "browser": self = .browser
        #endif
        #if os(iOS) || os(macOS)
        case "editor": self = .editor
        #endif
        #if !os(macOS)
        case "navigation_stack": self = .navigationStack
        #endif
        default: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for ToolbarPlacement"))
        }
    }
}
