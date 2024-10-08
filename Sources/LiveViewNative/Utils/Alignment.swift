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
/// - `topLeading`
/// - `top`
/// - `topTrailing`
/// - `leading`
/// - `center`
/// - `trailing`
/// - `bottomLeading`
/// - `bottom`
/// - `bottomTrailing`
/// - `leadingLastTextBaseline`
/// - `trailingLastTextBaseline`
extension Alignment: @retroactive Decodable, AttributeDecodable {
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
        case "topLeading":
            self = .topLeading
        case "top":
            self = .top
        case "topTrailing":
            self = .topTrailing
        case "leading":
            self = .leading
        case "center":
            self = .center
        case "trailing":
            self = .trailing
        case "bottomLeading":
            self = .bottomTrailing
        case "bottom":
            self = .bottom
        case "bottomTrailing":
            self = .bottomTrailing
        case "leadingLastTextBaseline":
            self = .leadingLastTextBaseline
        case "trailingLastTextBaseline":
            self = .trailingLastTextBaseline
        default:
            return nil
        }
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
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
/// - `listRowSeparatorLeading`
/// - `listRowSeparatorTrailing`
extension HorizontalAlignment: @retroactive Decodable, AttributeDecodable {
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
        #if os(iOS) || os(macOS)
        case "listRowSeparatorLeading":
            self = .listRowSeparatorLeading
        case "listRowSeparatorTrailing":
            self = .listRowSeparatorTrailing
        #endif
        default:
            return nil
        }
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
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
/// - `firstTextBaseline`
/// - `lastTextBaseline`
extension VerticalAlignment: @retroactive Decodable, AttributeDecodable {
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
        case "firstTextBaseline":
            self = .firstTextBaseline
        case "lastTextBaseline":
            self = .lastTextBaseline
        default:
            return nil
        }
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let result = Self(string: value) else { throw AttributeDecodingError.badValue(Self.self) }
        self = result
    }
}
