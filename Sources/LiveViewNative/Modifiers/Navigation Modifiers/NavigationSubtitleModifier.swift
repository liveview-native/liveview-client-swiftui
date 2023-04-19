//
//  NavigationSubtitleModifier.swift
// LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Configures the view’s subtitle for purposes of navigation.
///
/// ```html
/// <VStack modifiers={navigation_subtitle(@native, subtitle: "Subtitle Label")}>
///     <Text>Top</Text>
///     <Text>Bottom</Text>
/// </VStack>
/// ```
///
/// ## Arguments
/// * ``subtitle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(macOS 13.0, *)
struct NavigationSubtitleModifier: ViewModifier, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let subtitle: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subtitle = try container.decode(String.self, forKey: .subtitle)
    }

    func body(content: Content) -> some View {
        content
            #if os(macOS)
            .navigationSubtitle(subtitle)
            #endif
    }

    enum CodingKeys: String, CodingKey {
        case subtitle
    }
}
