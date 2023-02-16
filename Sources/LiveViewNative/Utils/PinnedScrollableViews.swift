//
//  PinnedScrollableViews.swift
//  
//
//  Created by Carson Katri on 2/16/23.
//

import SwiftUI

extension PinnedScrollableViews: Decodable {
    
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
}
