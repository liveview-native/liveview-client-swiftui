//
//  FrameModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/12/22.
//

import SwiftUI

enum FrameModifier: ViewModifier, Decodable, Equatable {
    case fixed(width: CGFloat?, height: CGFloat?, alignment: Alignment)
    case flexible(minWidth: CGFloat?, idealWidth: CGFloat?, maxWidth: CGFloat?, minHeight: CGFloat?, idealHeight: CGFloat?, maxHeight: CGFloat?, alignment: Alignment)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let alignment = try container.decodeIfPresent(Alignment.self, forKey: .alignment) ?? .center
        
        if container.allKeys.contains(.width) || container.allKeys.contains(.height) {
            guard Set(container.allKeys).subtracting([.width, .height, .alignment]).isEmpty else {
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "frame attribute cannot contain fixed and flexible parameters"))
            }
            self = .fixed(
                width: try container.decodeIfPresent(CGFloat.self, forKey: .width),
                height: try container.decodeIfPresent(CGFloat.self, forKey: .height),
                alignment: alignment
            )
        } else {
            guard !container.allKeys.contains(.width) && !container.allKeys.contains(.height) else {
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "frame attribute cannot contain fixed and flexible parameters"))
            }
            self = .flexible(
                minWidth: try container.decodeIfPresent(CGFloat.self, forKey: .minWidth),
                idealWidth: try container.decodeIfPresent(CGFloat.self, forKey: .idealWidth),
                maxWidth: try container.decodeIfPresent(CGFloat.self, forKey: .maxWidth),
                minHeight: try container.decodeIfPresent(CGFloat.self, forKey: .minHeight),
                idealHeight: try container.decodeIfPresent(CGFloat.self, forKey: .idealHeight),
                maxHeight: try container.decodeIfPresent(CGFloat.self, forKey: .maxHeight),
                alignment: alignment
            )
        }
    }
        
    init(string value: String) {
        let attributeDecoder = JSONDecoder()

        self = try! attributeDecoder.decode(Self.self, from: value.data(using: .utf8)!)
    }
    
    func body(content: Content) -> some View {
        switch self {
        case let .fixed(width: w, height: h, alignment: a):
            content.frame(width: w, height: h, alignment: a)
        case let .flexible(minWidth: minW, idealWidth: idealW, maxWidth: maxW, minHeight: minH, idealHeight: idealH, maxHeight: maxH, alignment: a):
            content.frame(minWidth: minW, idealWidth: idealW, maxWidth: maxW, minHeight: minH, idealHeight: idealH, maxHeight: maxH, alignment: a)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case alignment
        case width
        case height
        case minWidth = "min_width"
        case idealWidth = "ideal_width"
        case maxWidth = "max_width"
        case minHeight = "min_height"
        case idealHeight = "ideal_height"
        case maxHeight = "max_height"
    }
}
