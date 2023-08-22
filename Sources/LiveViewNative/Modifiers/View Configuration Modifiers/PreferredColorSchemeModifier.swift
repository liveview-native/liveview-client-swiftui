//
//  PreferredColorSchemeModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/24/23.
//

import SwiftUI

/// Overrides the preferred color scheme for the presentation.
/// - Note: This modifier propagates up to the nearest presentation container
/// rather than modifying the content directly.
///
/// ```html
/// <VStack
///     modifiers={
///         preferred_color_scheme(:light)
///     }
/// >
///   This view will present in light mode, regardless of the system setting.
/// </VStack>
/// ```
///
/// ## Arguments
/// * ``colorScheme``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct PreferredColorSchemeModifier: ViewModifier, Decodable {
    /// The preferred color scheme for the view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var colorScheme: ColorScheme?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decodeIfPresent(String.self, forKey: .colorScheme) {
            case "light":
                colorScheme = .light
            case "dark":
                colorScheme = .dark
            default:
                colorScheme = nil
        }
    }

    func body(content: Content) -> some View {
        content.preferredColorScheme(colorScheme)
    }

    enum CodingKeys: String, CodingKey {
        case colorScheme
    }
}
