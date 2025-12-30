//
//  Toggle.swift
//
//
//  Created by Carson Katri on 1/17/23.
//

import SwiftUI
import LightpandaClient

/// A form element that controls a boolean value.
///
/// Add elements within the toggle to provide a label.
///
/// ```html
/// <Toggle checked>
///     Lights On
/// </Toggle>
/// ```
///
/// ## Attributes
/// * ``checked``
@_documentation(visibility: public)
struct Toggle<Library: ElementLibrary>: View {
    var node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    /// Binding that reads/writes directly to the node's attributes
    private var isOn: Binding<Bool> {
        Binding(
            get: { node.attributes["checked"] != nil },
            set: { newValue in
                if newValue {
                    node.attributes["checked"] = ""
                } else {
                    node.attributes.removeValue(forKey: "checked")
                }
                // Dispatch change event to JS
                Task {
                    try? await self.node.callFunction(
                        runtime: lightpanda,
                        function: #"""
                        function() {
                            this.checked = \#(newValue);
                            this.dispatchEvent(new Event("change", { bubbles: true }));
                        }
                        """#
                    )
                }
            }
        )
    }
    
    public var body: some View {
        SwiftUI.Toggle(isOn: isOn) {
            node.children(library: Library.self)
        }
        .task {
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { [weak node] call in
                guard let node else { return }
                Task { @MainActor in
                    // Update node.attributes which triggers @Observable re-render
                    if call.payload == "true" {
                        node.attributes["checked"] = ""
                    } else {
                        node.attributes.removeValue(forKey: "checked")
                    }
                }
            }
            
            try? await self.node.callFunction(runtime: lightpanda, function: #"""
            function() {
                let internalValue = this.checked ?? false;
                Object.defineProperty(this, "checked", {
                    get() { return internalValue; },
                    set(newValue) {
                        internalValue = newValue;
                        globalThis["\#(id)"](String(newValue));
                    },
                    configurable: true
                });
            }
            """#)
        }
    }
}
