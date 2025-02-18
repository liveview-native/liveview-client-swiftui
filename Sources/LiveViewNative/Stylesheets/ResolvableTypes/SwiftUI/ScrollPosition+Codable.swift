//
//  ScrollPosition+Encodable.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/18/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension ScrollPosition: Codable, AttributeDecodable {
    enum CodingKeys: String, CodingKey {
        case edge
        case isPositionedByUser
        case point
        case viewID
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.edge?.rawValue, forKey: .edge)
        try container.encode(self.isPositionedByUser, forKey: .isPositionedByUser)
        try container.encode(self.point, forKey: .point)
        if let viewID = self.viewID(type: String.self) {
            try container.encode(viewID, forKey: .viewID)
        } else if let viewID = self.viewID(type: Int.self) {
            try container.encode(viewID, forKey: .viewID)
        }
    }
    
    public init(from decoder: any Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let point = try container.decodeIfPresent(CGPoint.self, forKey: .point) {
            self = .init(point: point)
        } else if let edge = try container.decodeIfPresent(Int8.self, forKey: .edge) {
            self = .init(edge: Edge(rawValue: edge)!)
        } else if let id = try container.decodeIfPresent(String.self, forKey: .viewID) {
            self = .init(id: id)
        } else {
            self = .init(id: try container.decode(Int.self, forKey: .viewID))
        }
    }
    
    public init(from attribute: Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = .init(id: value)
    }
}
