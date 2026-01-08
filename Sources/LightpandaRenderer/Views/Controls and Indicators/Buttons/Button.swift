//
//  Button.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LightpandaClient

/// `<Button>`, sends events when tapped.
///
/// Use the `phx-click` attribute to specify which event to fire on tap.
///
/// ```html
/// <Button phx-click="my_event" phx-value-extra="more info">Click Me!</Button>
/// ```
///
/// ```elixir
/// def handle_event("my_event", %{ "extra" => extra }, socket) do
///     {:noreply, assign(socket, value: extra)}
/// end
/// ```
/// 
/// ## Attributes
/// * ``role``
///
/// ## Events
/// * ``click``
@_documentation(visibility: public)
@_spi(LiveForm)
public struct Button<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    /// The semantic role of the button.
    ///
    /// Possible values:
    /// * `destructive`
    /// * `cancel`
    @_documentation(visibility: public)
    private var role: ButtonRole? {
        node.attributeValue(for: "role", strategy: .buttonRole)
    }
    
    public var body: some View {
        SwiftUI.Button(role: role, action: self.handleClick) {
            node.children(library: Library.self)
        }
    }
    
    private func handleClick() {
        Task {
            try await self.node.callFunction(
                runtime: lightpanda,
                function: #"""
                function() {
                    this.dispatchEvent(new MouseEvent("mousedown", { x: 0, y: 0, bubbles: true, cancelable: true }));
                    this.dispatchEvent(new MouseEvent("click", { x: 0, y: 0, bubbles: true, cancelable: true, view: window, detail: 1 }));
                }
                """#
            )
        }
    }
}

extension ParseStrategy where Self == ButtonRoleParseStrategy {
    static var buttonRole: ButtonRoleParseStrategy { ButtonRoleParseStrategy() }
}

struct ButtonRoleParseStrategy: ParseStrategy {
    typealias ParseInput = String
    typealias ParseOutput = ButtonRole
    
    func parse(_ value: String) throws -> ButtonRole {
        // Strip leading dot if present (e.g., ".destructive" -> "destructive")
        let normalizedValue = value.hasPrefix(".") ? String(value.dropFirst()) : value
        
        switch normalizedValue {
        case "cancel":
            return .cancel
        #if os(iOS)
        case "close":
            return .close
        case "confirm":
            return .confirm
        #endif
        case "destructive":
            return .destructive
        default:
            throw ParseError()
        }
    }
}
