//
//  ToolbarRoleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/30/2023.
//

import SwiftUI

/// Sets the semantic role of the toolbar.
///
/// A toolbar's role can affect its layout on certain platforms.
///
/// ```html
/// <Text modifiers={toolbar_role(:browser)}>
///     ...
/// </Text>
/// ```
///
/// See ``LiveViewNative/SwiftUI/ToolbarRole`` for more details on the available roles.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ToolbarRoleModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The role of the toolbar.
    ///
    /// See ``LiveViewNative/SwiftUI/ToolbarRole`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let role: ToolbarRole

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.role = try container.decode(ToolbarRole.self, forKey: .role)
    }

    func body(content: Content) -> some View {
        content.toolbarRole(role)
    }

    enum CodingKeys: String, CodingKey {
        case role
    }
}
