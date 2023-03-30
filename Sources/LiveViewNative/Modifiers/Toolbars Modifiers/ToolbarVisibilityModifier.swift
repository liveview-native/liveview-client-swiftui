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

        self.visibility = try container.decode(Visibility.self, forKey: .visibility)
        
        self.bars = try container.decode(ToolbarPlacement.self, forKey: .bars)
    }

    func body(content: Content) -> some View {
        content.toolbar(visibility, for: bars)
    }

    enum CodingKeys: String, CodingKey {
        case visibility
        case bars
    }
}
