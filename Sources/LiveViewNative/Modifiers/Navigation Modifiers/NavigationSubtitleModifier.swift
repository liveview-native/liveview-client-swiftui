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
/// <VStack modifiers={navigation_subtitle("Subtitle Label")}>
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

    func body(content: Content) -> some View {
        content
            #if os(macOS)
            .navigationSubtitle(subtitle)
            #endif
    }
}
