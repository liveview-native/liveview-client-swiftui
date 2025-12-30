//
//  SecureField.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI
import LightpandaClient

/// A form element for entering private text.
///
/// This element is similar to ``TextField`` but for secure text, such as passwords.
///
/// ```html
/// <SecureField prompt="Required">
///     Password
/// </SecureField>
/// ```
///
/// ## Attributes
/// * ``prompt``
@_documentation(visibility: public)
struct SecureField<Library: ElementLibrary>: View {
    var node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    /// Additional guidance on what to enter.
    @_documentation(visibility: public)
    private var prompt: String? {
        node.attributeValue(for: "prompt")
    }
    
    var body: some View {
        SwiftUI.SecureField(
            text: Binding(
                get: { node.value },
                set: { newValue in
                    node.value = newValue
                    Task {
                        try? await self.node.callFunction(
                            runtime: lightpanda,
                            function: #"""
                            function() {
                                this.value = \#(String(data: try! JSONEncoder().encode(newValue), encoding: .utf8)!);
                                this.dispatchEvent(new Event("input", {
                                    inputType: "insertText",
                                    data: "\#(newValue.last ?? " ")",
                                    bubbles: true
                                }));
                            }
                            """#
                        )
                    }
                }
            ),
            prompt: prompt.flatMap(SwiftUI.Text.init)
        ) {
            node.children(library: Library.self)
        }
        .task {
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { [weak node] call in
                node?.value = call.payload
            }
            
            try? await self.node.callFunction(runtime: lightpanda, function: #"""
            function() {
                let internalValue = this.value ?? "";
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
    }
}
