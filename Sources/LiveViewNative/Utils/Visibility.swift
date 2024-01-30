//
//  Visibility.swift
//  
//
//  Created by Carson Katri on 3/30/23.
//

import SwiftUI
import LiveViewNativeCore

/// A value that represents a hidden state.
///
/// Possible values:
/// * `automatic`
/// * `visible`
/// * `hidden`
extension Visibility: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let value = Self(from: attributeValue) else { throw AttributeDecodingError.badValue(Self.self) }
        self = value
    }
}

extension Visibility {
    init?(from string: String) {
        switch string {
        case "visible": self = .visible
        case "hidden": self = .hidden
        case "automatic": self = .automatic
        default: return nil
        }
    }
}
