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
        // TODO: handle click events
        fatalError()
    }
}

extension ParseStrategy where Self == ButtonRoleParseStrategy {
    static var buttonRole: ButtonRoleParseStrategy { ButtonRoleParseStrategy() }
}

struct ButtonRoleParseStrategy: ParseStrategy {
    typealias ParseInput = String
    typealias ParseOutput = ButtonRole
    
    func parse(_ value: String) throws -> ButtonRole {
        switch value {
        case "cancel":
            return .cancel
        case "close":
            return .close
        case "confirm":
            return .confirm
        case "destructive":
            return .destructive
        default:
            throw ParseError()
        }
    }
}
