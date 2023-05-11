//
//  OnMoveCommandModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/9/2023.
//

import SwiftUI

/// Receive an event when the arrow keys are pressed on a focused element.
/// 
/// - Note: This modifier must be used on an element that can receive focus.
/// 
/// Create an event with a `direction` parameter.
/// 
/// ```elixir
/// defmodule MyAppWeb.SliderLive do
///   native_binding :value, Float, 0
///    
///   @impl true
///   def handle_event("adjust", %{ "direction" => direction }, socket) do
///     case direction do
///       "right" ->
///         {:noreply, assign_native_bindings(socket, value: socket.assigns.value + 0.1)}
///       "left" ->
///         {:noreply, assign_native_bindings(socket, value: socket.assigns.value - 0.1)}
///       _ ->
///         {:noreply, socket}
///     end
///   end
/// end
/// ```
///
/// Pass the name of this event to the ``action`` argument.
///
/// ```html
/// <Slider value-binding="value" modifiers={on_move_command(@native, action: "adjust")}>
///     Value
/// </Slider>
/// ```
/// 
/// Now when the slider is focused, the left/right keys can be used to adjust the value.
///
/// ## Arguments
/// * ``action``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(macOS 13.0, tvOS 16.0, *)
struct OnMoveCommandModifier: ViewModifier, Decodable {
    /// The event to trigger when the command is received.
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
        content
            #if os(macOS) || os(tvOS)
            .onMoveCommand { direction in
                switch direction {
                case .up:
                    action(value: ["direction": "up"])
                case .down:
                    action(value: ["direction": "down"])
                case .left:
                    action(value: ["direction": "left"])
                case .right:
                    action(value: ["direction": "right"])
                @unknown default:
                    action(value: ["direction": String(describing: direction)])
                }
            }
            #endif
    }

    enum CodingKeys: String, CodingKey {
        case action
    }
}
