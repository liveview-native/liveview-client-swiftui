//
//  OnDeleteCommandModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/9/2023.
//

import SwiftUI

/// Sends an event when a system delete command is received.
/// 
/// Create an event to handle the delete action.
///
/// ```elixir
/// defmodule MyAppWeb.ListLive do
///   def handle_event("remove_last", _params, socket):
///     {:noreply, assign(socket, :count, socket.assigns.count - 1)}
///   end
/// end
/// ```
/// 
/// Pass the name of this event to the ``action`` argument.
/// 
/// ```html
/// <List modifiers={on_delete_command(perform: "remove_last")}>
///   <%= for i <- 0..@count do %>
///     <Text id={"#{i}"}>
///       <%= i %>
///     </Text>
///   <% end %>
/// </List>
/// ```
/// 
/// Whenever backspace or delete is pressed, the number of items in the list is decreased.
/// 
/// ## Arguments
/// * ``perform``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(macOS 13.0, *)
struct OnDeleteCommandModifier: ViewModifier, Decodable {
    /// The event to trigger when the delete command is received.
    /// 
    /// See [`Event`](doc:Event/init(from:)) for more details on referencing events.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event private var perform: Event.EventHandler

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self._perform = try container.decode(Event.self, forKey: .perform)
    }

    func body(content: Content) -> some View {
        content
            #if os(macOS)
            .onDeleteCommand {
                perform()
            }
            #endif
    }

    enum CodingKeys: String, CodingKey {
        case perform
    }
}
