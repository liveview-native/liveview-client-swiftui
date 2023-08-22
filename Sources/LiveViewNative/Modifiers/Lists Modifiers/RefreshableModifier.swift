//
//  RefreshableModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/11/2023.
//

import SwiftUI

/// Adds pull to refresh functionality to scrollable elements.
///
/// Provide the name of an event to trigger when the system refresh action is triggered.
///
/// ```html
/// <List modifiers={refreshable(action: "reload_items")}>
///     ...
/// </List>
/// ```
///
/// A map can be specified as well to customize the event handling. See [`Event`](doc:Event/init(from:)) for more details.
///
/// ```html
/// <List modifiers={refreshable(action: %{ :event => "reload_items", :params => %{ "index" => 1 } })}>
///     ...
/// </List>
/// ```
///
/// ## Arguments
/// * ``action``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct RefreshableModifier: ViewModifier, Decodable {
    /// The event to trigger when refreshed.
    ///
    /// See [`Event`](doc:Event/init(from:)) for more details on referencing events.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event private var action: Event.EventHandler

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._action = try container.decode(Event.self, forKey: .action)
    }

    func body(content: Content) -> some View {
        content.refreshable {
            try? await self.action.callAsFunction()
        }
    }

    enum CodingKeys: String, CodingKey {
        case action
    }
}
