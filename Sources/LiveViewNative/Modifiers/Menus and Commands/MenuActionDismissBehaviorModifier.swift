//
//  MenuActionDismissBehaviorModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/12/23.
//

import SwiftUI

/// Controls whether a menu is dismissed automatically after an action is performed.
///
/// ```html
/// <Menu modifiers={menu_action_dismiss_behavior(:disabled)}>
///     <Text template={:label}>
///         Edit Actions
///     </Text>
///     <Group template={:content}>
///         <Button phx-click="arrange">Arrange</Button>
///         <Button phx-click="update">Update</Button>
///         <Button phx-click="remove">Remove</Button>
///     </Group>
/// </Menu>
/// ```
///
/// ## Arguments
/// - ``behavior``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
struct MenuActionDismissBehaviorModifier: ViewModifier, Decodable {
    /// Whether  the menu is dismissed when an action is performed.
    ///
    /// Possible values:
    /// - `automatic`
    /// - `disabled`: The menu will not be dismissed (only available on iOS)
    /// - `enabled`: The menu will be dismissed
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let behavior: MenuActionDismissBehavior
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .behavior) {
        case "automatic":
            self.behavior = .automatic
        case "enabled":
            self.behavior = .enabled
        #if os(iOS)
        case "disabled":
            self.behavior = .disabled
        #endif
        case let value:
            throw DecodingError.dataCorruptedError(forKey: .behavior, in: container, debugDescription: "Invalid value '\(value)' for MenuActionDismissBehavior")
        }
    }
    
    func body(content: Content) -> some View {
        content.menuActionDismissBehavior(behavior)
    }
    
    enum CodingKeys: String, CodingKey {
        case behavior
    }
}
