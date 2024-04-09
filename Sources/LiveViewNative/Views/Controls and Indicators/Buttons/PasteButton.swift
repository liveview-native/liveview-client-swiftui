//
//  PasteButton.swift
//  
//
//  Created by Carson Katri on 3/2/23.
//
import SwiftUI

/// Sends an event with the clipboard's contents when tapped.
///
/// Use the `phx-click` attribute to specify which event to fire on tap.
///
/// ```html
/// <PasteButton phx-click="my_event" />
/// ```
///
/// ```elixir
/// def handle_event("my_event", %{ "value" => value }, socket) do
///   {:noreply, assign(socket, :pasted_value, hd(value))}
/// end
/// ```
///
/// > ``PasteButton`` only sends copied `String` types.
///
/// ## Events
/// * ``click``
@_documentation(visibility: public)
@available(iOS 16.0, macOS 13.0, *)
@LiveElement
struct PasteButton<Root: RootRegistry>: View {
    /// Event sent when tapped.
    ///
    /// Sends a payload with the following format:
    ///
    /// ```json
    /// {
    ///     "value": [
    ///         "clipboard string 1",
    ///         "clipboard string 2",
    ///         ...
    ///     ]
    /// }
    /// ```
    @_documentation(visibility: public)
    @Event("phx-click", type: "click") private var click
    
    var body: some View {
        #if os(iOS) || os(macOS)
        SwiftUI.PasteButton(payloadType: String.self) { strings in
            click(value: ["value": strings]) {}
        }
            .preference(key: _ProvidedBindingsKey.self, value: ["phx-click"])
        #endif
    }
}
