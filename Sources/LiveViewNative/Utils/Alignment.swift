//
//  Alignment.swift
// LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI
import LiveViewNativeCore

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
    
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let result = Self(string: value) else { throw AttributeDecodingError.badValue(Self.self) }
        self = result
    }
}

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
