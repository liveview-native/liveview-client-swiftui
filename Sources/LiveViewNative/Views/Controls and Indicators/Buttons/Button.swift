//
//  Button.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

/// `<button>`, sends events when tapped.
///
/// Use the `phx-click` attribute to specify which event to fire on tap.
///
/// ```html
/// <button phx-click="my_event" phx-value-extra="more info">Click Me!</button>
/// ```
///
/// ```elixir
/// def handle_event("my_event", %{ "extra" => extra }, socket) do
///     {:noreply, assign(socket, value: extra)}
/// end
/// ```
/// 
/// ## Attributes
/// * ``disabled``
/// * ``buttonStyle``
/// 
/// ## Events
/// * ``click``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@_spi(LiveForm)
public struct Button<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    // used internaly by PhxSubmitButton
    private let action: (() -> Void)?
    
    /// Event triggered when tapped.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event("phx-click", type: "click") private var click
    
    /// Boolean attribute that indicates whether the button is tappable.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("disabled") private var disabled: Bool
    /// The style to apply to this button.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("button-style") private var buttonStyle: ButtonStyle = .automatic
    
    @_spi(LiveForm) public init(action: (() -> Void)?) {
        self.action = action
    }
    
    public var body: some View {
        SwiftUI.Button(action: self.handleClick) {
            context.buildChildren(of: element)
        }
        .applyButtonStyle(buttonStyle)
        .disabled(disabled)
        .preference(key: ProvidedBindingsKey.self, value: ["phx-click"])
    }
    
    private func handleClick() {
        if let action = action {
            action()
            return
        }
        click(value: element.buildPhxValuePayload()) {}
    }
}

/// A style for the ``Button`` element.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum ButtonStyle: String, AttributeDecodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case bordered
    /// `bordered-prominent`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case borderedProminent = "bordered-prominent"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case borderless
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case plain
}

fileprivate extension View {
    @ViewBuilder
    func applyButtonStyle(_ style: ButtonStyle) -> some View {
        switch style {
        case .automatic:
            self.buttonStyle(.automatic)
        case .bordered:
            self.buttonStyle(.bordered)
        case .borderedProminent:
            self.buttonStyle(.borderedProminent)
        case .borderless:
            self.buttonStyle(.borderless)
        case .plain:
            self.buttonStyle(.plain)
        }
    }
}
