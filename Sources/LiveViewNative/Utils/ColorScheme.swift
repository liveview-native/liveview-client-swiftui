//
//  ColorScheme.swift
//  
//
//  Created by Carson Katri on 3/30/23.
//

import SwiftUI
import LiveViewNativeCore

/// A value that represents a system appearance.
///
/// Possible values:
/// * `light`
/// * `dark`
extension ColorScheme: Decodable, AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let value = Self(from: attributeValue) else { throw AttributeDecodingError.badValue(Self.self) }
        self = value
    }
    
    init?(from string: String) {
        switch string {
        case "light": self = .light
        case "dark": self = .dark
        default: return nil
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let value = Self(from: try container.decode(String.self))
        else { throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for ColorScheme")) }
        self = value
    }
}
