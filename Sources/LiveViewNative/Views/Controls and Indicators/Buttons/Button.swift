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
    
    @_spi(LiveForm) public init(action: (() -> Void)?) {
        self.action = action
    }
    
    public var body: some View {
        SwiftUI.Button(action: self.handleClick) {
            context.buildChildren(of: element)
        }
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
