//
//  TextEditor.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 2/8/23.
//

import SwiftUI
import LightpandaClient

/// A multi-line, long-form text editor.
///
/// ```html
/// <TextEditor />
/// ```
@_documentation(visibility: public)
struct TextEditor<Library: ElementLibrary>: View {
    var node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    var body: some View {
        #if os(iOS) || os(macOS)
        SwiftUI.TextEditor(text: Binding(
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
        ))
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
        #endif
    }
}
