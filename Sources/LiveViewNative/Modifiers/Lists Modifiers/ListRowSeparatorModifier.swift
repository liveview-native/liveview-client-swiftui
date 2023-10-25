//
//  ListRowSeparatorModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/14/22.
//

import SwiftUI

struct ListRowSeparatorModifier: ViewModifier, Decodable, Equatable {
    // TODO: Documentation
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
            let attributeDecoder = makeJSONDecoder()

            self = try! attributeDecoder.decode(ListRowSeparatorModifier.self, from: value.data(using: .utf8)!)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.visibility = try container.decode(Visibility.self, forKey: .visibility)
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
        #if os(watchOS) || os(tvOS)
        content
        #else
        content.listRowSeparator(visibility, edges: edges)
        #endif
    }
    
    private enum CodingKeys: String, CodingKey {
        case visibility, edges
    }
}
