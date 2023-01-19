//
//  NavigationTitleModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/12/22.
//

import SwiftUI

struct NavigationTitleModifier: ViewModifier, Decodable, Equatable {
    fileprivate let title: String
    private let cached: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.cached = false
    }
    
    init(title: String, cached: Bool = false) {
        self.title = title
        self.cached = cached
    }
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .preference(key: NavigationTitleModifierKey.self, value: cached ? nil : self)
    }
    
    enum CodingKeys: String, CodingKey {
        case title
    }
}

/// A key that passes the navigation title up the View hierarchy via preferences.
enum NavigationTitleModifierKey: PreferenceKey {
    static var defaultValue: NavigationTitleModifier?
    
    static func reduce(value: inout NavigationTitleModifier?, nextValue: () -> NavigationTitleModifier?) {
        value = nextValue().flatMap({ .init(title: $0.title, cached: true) }) ?? value
    }
}
