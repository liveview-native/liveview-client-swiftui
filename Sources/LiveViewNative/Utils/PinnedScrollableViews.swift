//
//  PinnedScrollableViews.swift
//  
//
//  Created by Carson Katri on 2/16/23.
//

import SwiftUI
import LiveViewNativeCore

extension PinnedScrollableViews: Decodable, AttributeDecodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self = Self(string: string)
    }
    
    init(string: String) {
        switch string {
        case "section-headers":
            self = .sectionHeaders
        case "section-footers":
            self = .sectionFooters
        case "all":
            self = [.sectionHeaders, .sectionFooters]
        default:
            self = .init()
        }
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self.init(string: value)
    }
}
