//
//  ImageModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 6/1/23.
//

import SwiftUI
import LiveViewNativeCore

enum ImageModifierType: String, Decodable {
    case resizable
    case antialiased
    case symbolRenderingMode = "symbol_rendering_mode"
    case renderingMode = "rendering_mode"
    case interpolation
    
    func decode(from decoder: Decoder) throws -> any ImageModifier {
        switch self {
        case .resizable:
            return try ResizableModifier(from: decoder)
        case .antialiased:
            return try AntialiasedModifier(from: decoder)
        case .symbolRenderingMode:
            return try SymbolRenderingModeModifier(from: decoder)
        case .renderingMode:
            return try RenderingModeModifier(from: decoder)
        case .interpolation:
            return try InterpolationModifier(from: decoder)
        }
    }
}

/// A modifier that applies to an ``Image``.
protocol ImageModifier {
    /// Modify the `Image` and return the new `Image` type.
    func apply(to image: SwiftUI.Image) -> SwiftUI.Image
}

struct ImageModifierStack: Decodable, AttributeDecodable {
    var stack: [any ImageModifier]
    
    init(_ stack: [any ImageModifier]) {
        self.stack = stack
    }
    
    init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = try makeJSONDecoder().decode(Self.self, from: Data(value.utf8))
    }
    
    enum ImageModifierContainer: Decodable {
        case modifier(any ImageModifier)
        case end
        
        init(from decoder: Decoder) throws {
            let type = try decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .type)
            if let modifierType = ImageModifierType(rawValue: type) {
                self = .modifier(try modifierType.decode(from: decoder))
            } else {
                self = .end
            }
        }
        
        enum CodingKeys: CodingKey {
            case type
        }
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.stack = []
        while !container.isAtEnd {
            switch try container.decode(ImageModifierContainer.self) {
            case let .modifier(modifier):
                self.stack.append(modifier)
            case .end:
                return
            }
        }
    }
}
