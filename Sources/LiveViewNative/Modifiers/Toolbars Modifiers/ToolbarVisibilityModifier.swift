//
//  ToolbarVisibilityModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/30/2023.
//

import SwiftUI

/// Sets the visibility of a toolbar.
/// 
/// ```html
/// <Text modifiers={
///     toolbar(content: "my-toolbar")
///     |> toolbar_visibility(visibility: :hidden, bars: :)
/// }>
///     ...
/// </Text>
/// ````
///
/// ## Arguments
/// * ``visibility``
/// * ``bars``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ToolbarVisibilityModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The visibility of the toolbar.
    /// 
    /// Possible values:
    /// * `automatic`
    /// * `visible`
    /// * `hidden`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let visibility: Visibility

    /// The bars to set the visibility of.
    /// 
    /// Possible values:
    /// * `automatic`
    /// * `bottom_bar`
    /// * `navigation_bar`
    /// * `tab_bar`
    /// * `window_toolbar`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let bars: ToolbarPlacement

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .visibility) {
        case "automatic": self.visibility = .automatic
        case "hidden": self.visibility = .hidden
        case "visible": self.visibility = .visible
        default: fatalError("Unknown value for visibility")
        }

        switch try container.decode(String.self, forKey: .bars) {
        case "automatic": self.bars = .automatic
        #if os(iOS)
        case "bottom_bar": self.bars = .bottomBar
        #endif
        #if !os(macOS)
        case "navigation_bar": self.bars = .navigationBar
        #endif
        #if os(iOS) || os(tvOS)
        case "tab_bar": self.bars = .tabBar
        #endif
        #if os(macOS)
        case "window_toolbar": self.bars = .windowToolbar
        #endif
        default: fatalError("Unknown value for bars")
        }

    }

    func body(content: Content) -> some View {
        content.toolbar(visibility, for: bars)
    }

    enum CodingKeys: String, CodingKey {
        case visibility
        case bars
    }
}
