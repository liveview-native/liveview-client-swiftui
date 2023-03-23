//
//  ListRowSeparatorModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/14/22.
//

import SwiftUI

struct ListRowSeparatorModifier: ViewModifier, Decodable, Equatable {
    private let visibility: Visibility
    private let edges: VerticalEdge.Set
    
    init(string value: String) {
        switch value {
        case "hidden":
            self.visibility = .hidden
            self.edges = .all
        case "visible":
            self.visibility = .visible
            self.edges = .all
        case "automatic":
            self.visibility = .automatic
            self.edges = .all
        default:
            let attributeDecoder = JSONDecoder()

            self = try! attributeDecoder.decode(ListRowSeparatorModifier.self, from: value.data(using: .utf8)!)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .visibility) {
        case "hidden":
            self.visibility = .hidden
        case "visible":
            self.visibility = .visible
        case "automatic":
            self.visibility = .automatic
        default:
            throw DecodingError.dataCorruptedError(forKey: .visibility, in: container, debugDescription: "invalid value for visibility")
        }
        switch try container.decodeIfPresent(String.self, forKey: .edges) {
        case "top":
            self.edges = .top
        case "bottom":
            self.edges = .bottom
        default:
            self.edges = .all
        }
    }
    
    init(visibility: Visibility, edges: VerticalEdge.Set) {
        self.visibility = visibility
        self.edges = edges
    }
    
    func body(content: Content) -> some View {
        #if !os(watchOS)
        content.listRowSeparator(visibility, edges: edges)
        #else
        content
        #endif
    }
    
    private enum CodingKeys: String, CodingKey {
        case visibility, edges
    }
}
