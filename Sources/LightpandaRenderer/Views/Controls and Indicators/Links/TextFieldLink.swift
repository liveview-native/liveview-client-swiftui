//
//  TextFieldLink.swift
//  
//
//  Created by Carson Katri on 3/2/23.
//

import SwiftUI
import LightpandaClient

/// A form element that requests text input on Apple Watch.
///
/// This element displays a button that, when tapped, opens a dialogue for inputting text.
///
/// ```html
/// <TextFieldLink prompt="Favorite Color">
///     What's your favorite color?
/// </TextFieldLink>
/// ```
///
/// ## Attributes
/// * ``prompt``
@_documentation(visibility: public)
@available(watchOS 9.0, *)
struct TextFieldLink<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    @State private var value: String = ""
    
    /// Describes the reason for requesting text input.
    @_documentation(visibility: public)
    private var prompt: String? {
        node.attributeValue(for: "prompt")
    }
    
    /// The initial value.
    @_documentation(visibility: public)
    private var initialValue: String? {
        node.attributeValue(for: "value")
    }
    
    var body: some View {
        #if os(watchOS)
        SwiftUI.TextFieldLink(
            prompt: prompt.flatMap(SwiftUI.Text.init)
        ) {
            node.children(library: Library.self)
        } onSubmit: { newValue in
            value = newValue
            Task {
                let encodedValue = String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!
                try await self.node.callFunction(
                    runtime: lightpanda,
                    function: #"""
                    function() {
                        this.value = \#(encodedValue);
                        this.dispatchEvent(new Event("input", { bubbles: true }));
                        this.dispatchEvent(new Event("change", { bubbles: true }));
                    }
                    """#
                )
            }
        }
        .onAppear {
            value = initialValue ?? ""
        }
        .task {
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { call in
                Task { @MainActor in
                    value = call.payload
                }
            }
            
            let initialJS = initialValue.map { "\"\($0)\"" } ?? "\"\""
            try? await self.node.callFunction(runtime: lightpanda, function: #"""
            function() {
                let internalValue = \#(initialJS);
                Object.defineProperty(this, "value", {
                    get() { return internalValue; },
                    set(newValue) {
                        internalValue = newValue;
                        globalThis["\#(id)"](newValue);
                    },
                    configurable: true
                });
            }
            """#)
        }
        #endif
    }
}
