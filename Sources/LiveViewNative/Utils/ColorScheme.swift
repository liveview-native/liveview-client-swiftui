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
extension ColorScheme: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
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
}
