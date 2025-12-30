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
    let node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    /// Whether the toggle is on.
    @_documentation(visibility: public)
    private var checked: Bool {
        node.attributeBoolean(for: "checked")
    }
    
    @State private var isOn: Bool = false
    
    public var body: some View {
        SwiftUI.Toggle(isOn: $isOn) {
            node.children(library: Library.self)
        }
        .onAppear {
            isOn = checked
        }
        .onChange(of: isOn) { _, newValue in
            Task {
                try await self.node.callFunction(
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
        .task {
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { [weak node] call in
                if let value = Bool(call.payload) {
                    Task { @MainActor in
                        isOn = value
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
