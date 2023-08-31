//
//  OnSubmitModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/10/2023.
//

import SwiftUI

/// Receive an event when a field is submitted.
/// 
/// Apply this modifier to a ``TextField`` or ``SecureField`` to receive an event when the submit button is pressed.
/// 
/// ```html
/// <TextField modifiers={on_submit("submit")}>
///     Type here
/// </TextField>
/// ```
/// 
/// Use the `search` trigger to send the event when a ``SearchableModifier`` modifier is submitted.
/// 
/// ```html
/// <List modifiers={
///   searchable(text: :query)
///   |> on_submit(of: :search, "submit")
/// }>
///     ...
/// </List>
/// ```
/// 
/// ## Arguments
/// * ``triggers``
/// * ``action``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct OnSubmitModifier: ViewModifier, Decodable {
    /// The types of input that trigger the action. Defaults to `text`.
    /// 
    /// Possible values:
    /// * `:search`
    /// * `:text`
    /// * `[:search, :text]`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let triggers: SubmitTriggers

    /// The event to send.
    ///
    /// See [`Event`](doc:Event/init(from:)) for more details on referencing events.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event private var action: Event.EventHandler

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.triggers = try container.decodeIfPresent(SubmitTriggers.self, forKey: .triggers) ?? .text
        self._action = try container.decode(Event.self, forKey: .action)
    }

    func body(content: Content) -> some View {
        content.onSubmit(of: triggers) {
            action()
        }
    }

    enum CodingKeys: String, CodingKey {
        case triggers
        case action
    }
}

extension SubmitTriggers: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self = Self()
        while !container.isAtEnd {
            switch try container.decode(String.self) {
            case "search":
                self.insert(.search)
            case "text":
                self.insert(.text)
            case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "unknown SubmitTriggers value '\(`default`)'"))
            }
        }
    }
}
