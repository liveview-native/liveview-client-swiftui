//
//  ToolbarBackgroundModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/30/2023.
//

import SwiftUI

/// Sets the visibility and style of a toolbar's background.
///
/// Pass the ``style`` argument to change the background of a particular toolbar.
/// For example, we can make the navigation bar use the system red color.
///
/// ```html
/// <Text modifiers={toolbar_background({:color, :red}, bars: :navigation_bar)}>
///     ...
/// </Text>
/// ```
///
/// Use the ``visibility`` argument to hide or show a toolbar background.
///
/// ```html
/// <Text modifiers={toolbar_background(:hidden, bars: :navigation_bar)}>
///     ...
/// </Text>
/// ```
///
/// ## Arguments
/// * ``style``
/// * ``visibility``
/// * ``bars``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ToolbarBackgroundModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The `ShapeStyle` to use for the background.
    ///
    /// See ``LiveViewNative/SwiftUI/AnyShapeStyle`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: AnyShapeStyle?
    
    /// The visibility of the background.
    ///
    /// See ``LiveViewNative/SwiftUI/Visibility`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let visibility: Visibility?

    /// The toolbars to modify.
    ///
    /// See ``LiveViewNative/SwiftUI/ToolbarPlacement`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let bars: ToolbarPlacement

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.style = try container.decodeIfPresent(AnyShapeStyle.self, forKey: .style)
        self.visibility = try container.decodeIfPresent(Visibility.self, forKey: .visibility)
        self.bars = try container.decode(ToolbarPlacement.self, forKey: .bars)
    }

    func body(content: Content) -> some View {
        content
            .applyToolbarBackground(style, for: bars)
            .applyToolbarBackground(visibility, for: bars)
    }

    enum CodingKeys: String, CodingKey {
        case style
        case visibility
        case bars
    }
}

extension View {
    @ViewBuilder
    func applyToolbarBackground(_ style: AnyShapeStyle?, for bars: ToolbarPlacement) -> some View {
        if let style {
            self.toolbarBackground(style, for: bars)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func applyToolbarBackground(_ visibility: Visibility?, for bars: ToolbarPlacement) -> some View {
        if let visibility {
            self.toolbarBackground(visibility, for: bars)
        } else {
            self
        }
    }
}
