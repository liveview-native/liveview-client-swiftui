//
//  ToolbarColorSchemeModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/30/2023.
//

import SwiftUI

/// Sets the color scheme for a toolbar.
///
/// Pass the ``colorScheme`` argument to change the color scheme of the toolbar's background.
///
/// ```html
/// <Text modifiers={toolbar_color_scheme(:dark, bars: :navigation_bar)}>
///     ...
/// </Text>
/// ```
///
/// ## Arguments
/// * ``colorScheme``
/// * ``bars``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ToolbarColorSchemeModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// `color_scheme`, The `ColorScheme` to use for the specified bars.
    ///
    /// See ``LiveViewNative/SwiftUI/ColorScheme`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let colorScheme: ColorScheme?

    /// The bars to apply the color scheme to.
    ///
    /// See ``LiveViewNative/SwiftUI/ToolbarPlacement`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let bars: ToolbarPlacement

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.colorScheme = try container.decodeIfPresent(ColorScheme.self, forKey: .colorScheme)
        self.bars = try container.decode(ToolbarPlacement.self, forKey: .bars)
    }

    func body(content: Content) -> some View {
        content.toolbarColorScheme(colorScheme, for: bars)
    }

    enum CodingKeys: String, CodingKey {
        case colorScheme
        case bars
    }
}
