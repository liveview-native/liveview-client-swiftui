//
//  NavigationTitleModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/12/22.
//

import SwiftUI

/// Configures the view’s title for purposes of navigation, using a string.
///
/// ```html
/// <VStack modifiers={navigation_title("Navigation Title")}>
///     <Text>Top</Text>
///     <Text>Bottom</Text>
/// </VStack>
/// ```
///
/// ## Arguments
/// * ``title``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct NavigationTitleModifier: ViewModifier, Decodable, Equatable {
    /// The string to display.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
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
