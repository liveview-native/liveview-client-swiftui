//
//  Alignment.swift
// LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI
import LiveViewNativeCore

/// Decodes a 2-axis alignment from a string.
///
/// Possible values:
/// - `top-leading`
/// - `top`
/// - `top-trailing`
/// - `leading`
/// - `center`
/// - `trailing`
/// - `bottom-leading`
/// - `bottom`
/// - `bottom-trailing`
/// - `leading-last-text-baseline`
/// - `trailing-last-text-baseline`
extension Alignment: Decodable, AttributeDecodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let alignment = Self(string: string) {
            self = alignment
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for Alignment"))
        }
    }
    
    init?(string: String) {
        switch string {
        case "top-leading", "top_leading":
            self = .topLeading
        case "top":
            self = .top
        case "top-trailing", "top_trailing":
            self = .topTrailing
        case "leading":
            self = .leading
        case "center":
            self = .center
        case "trailing":
            self = .trailing
        case "bottom-leading", "bottom_leading":
            self = .bottomTrailing
        case "bottom":
            self = .bottom
        case "bottom-trailing", "bottom_trailing":
            self = .bottomTrailing
        case "leading-last-text-baseline", "leading_last_text_baseline":
            self = .leadingLastTextBaseline
        case "trailing-last-text-baseline", "trailing_last_text_baseline":
            self = .trailingLastTextBaseline
        default:
            return nil
        }
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let result = Self(string: value) else { throw AttributeDecodingError.badValue(Self.self) }
        self = result
    }
}

/// Decodes a horizontal alignment from a string.
///
/// Possible values:
/// - `leading`
/// - `center`
/// - `trailing`
extension HorizontalAlignment: Decodable, AttributeDecodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let alignment = Self(string: string) {
            self = alignment
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for HorizontalAlignment"))
        }
    }
    
    init?(string: String) {
        switch string {
        case "center":
            self = .center
        case "leading":
            self = .leading
        case "trailing":
            self = .trailing
        default:
            return nil
        }
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let result = Self(string: value) else { throw AttributeDecodingError.badValue(Self.self) }
        self = result
    }
}

/// Decodes a vertical alignment from a string.
///
/// Possible values:
/// - `top`
/// - `center`
/// - `bottom`
extension VerticalAlignment: Decodable, AttributeDecodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let alignment = Self(string: string) {
            self = alignment
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for VerticalAlignment"))
        }
    }
    
    init?(string: String) {
        switch string {
        case "center":
            self = .center
        case "top":
            self = .top
        case "bottom":
            self = .bottom
        default:
            return nil
        }
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let result = Self(string: value) else { throw AttributeDecodingError.badValue(Self.self) }
        self = result
    }
}
