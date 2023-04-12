//
//  OnHoverModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/12/2023.
//

import SwiftUI

/// Receive an event when the cursor enters/leaves the element.
///
/// Create an event to handle the hover state change. A single boolean parameter is passed.
/// `true` indicates that the cursor entered the element, and `false` indicates that it left.
///
/// ```elixir
/// defmodule MyAppWeb.HoverLive do
///   def handle_event("hover", true, socket):
///     IO.puts("Began Hovering")
///     {:noreply, socket}
///   end
///   def handle_event("hover", false, socket):
///     IO.puts("Stopped Hovering")
///     {:noreply, socket}
///   end
/// end
/// ```
///
/// Pass the name of this event to the ``action`` argument.
///
/// ```html
/// <Text modifiers={on_hover(@native, action: "hover")}>Hover Here</Text>
/// ```
///
/// ## Arguments
/// * ``action``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct OnHoverModifier: ViewModifier, Decodable {
    /// The event to trigger when hovering.
    ///
    /// See [`Event`](doc:Event/init(from:)) for more details on referencing events.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let action: Event

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.action = try container.decode(Event.self, forKey: .action)
    }

    func body(content: Content) -> some View {
        content
            #if os(iOS) || os(macOS)
            .onHover { isHovering in
                Task {
                    try await action.wrappedValue.callAsFunction(value: isHovering)
                }
            }
            #endif
    }

    enum CodingKeys: String, CodingKey {
        case action
    }
}
