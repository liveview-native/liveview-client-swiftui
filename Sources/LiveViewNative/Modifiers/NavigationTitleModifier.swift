//
//  NavigationTitleModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/12/22.
//

import SwiftUI

struct NavigationTitleModifier: ViewModifier, Decodable, Equatable {
    private let title: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
    }
    
    init(title: String) {
        self.title = title
    }
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
    }
    
    enum CodingKeys: String, CodingKey {
        case title
    }
}
