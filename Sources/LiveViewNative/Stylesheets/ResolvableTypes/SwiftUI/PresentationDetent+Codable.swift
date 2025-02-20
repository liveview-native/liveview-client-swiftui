//
//  PresentationDetent.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 2/18/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

extension PresentationDetent: Codable, AttributeDecodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .medium:
            try container.encode("medium")
        case .large:
            try container.encode("large")
        default:
            fatalError("detent '\(self)' cannot be encoded")
        }
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        switch try container.decode(String.self) {
        case "medium":
            self = .medium
        case "large":
            self = .large
        case let `default`:
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "unknown PresentationDetent '\(`default`)'"))
        }
    }
    
    public init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "medium":
            self = .medium
        case "large":
            self = .large
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
