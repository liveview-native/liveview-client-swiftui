//
//  Picker.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 2/8/23.
//

import SwiftUI
import LightpandaClient

/// A control that picks one of multiple values.
///
/// The value of a picker is the `tag` attribute of the selected option.
///
/// Use the `content` children to specify the options for the picker, and the `label` children to provide a label.
///
/// ```html
/// <Picker selection="car">
///     <Text template="label">Transportation</Text>
///     <Group template="content">
///         <Label systemImage="car" tag="car">Car</Label>
///         <Label systemImage="bus" tag="bus">Bus</Label>
///         <Label systemImage="tram" tag="tram">Tram</Label>
///     </Group>
/// </Picker>
/// ```
///
/// ## Attributes
/// - ``selection``
///
/// ## Children
/// - `content`
/// - `label`
@_documentation(visibility: public)
struct Picker<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    @State private var selection: String? = nil
    
    /// The initial selection value.
    @_documentation(visibility: public)
    private var initialSelection: String? {
        node.attributeValue(for: "selection")
    }
    
    var body: some View {
        SwiftUI.Picker(selection: $selection) {
            ForEach(node.children.filter({ $0.attributeValue(for: "template") == "content" }).flatMap(\.children), id: \.id) { child in
                NodeView<Library>(node: child)
                    .tag(child.attributeValue(for: "tag") as String?)
            }
        } label: {
            node.children(in: "label", library: Library.self)
        }
        .onAppear {
            selection = initialSelection
        }
        .onChange(of: selection) { _, newValue in
            Task {
                let encodedValue = newValue.map { String(data: try! JSONEncoder().encode($0), encoding: .utf8)! } ?? "null"
                try await self.node.callFunction(
                    runtime: lightpanda,
                    function: #"""
                    function() {
                        this.value = \#(encodedValue);
                        this.dispatchEvent(new Event("change", { bubbles: true }));
                    }
                    """#
                )
            }
        }
        .task {
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { call in
                Task { @MainActor in
                    selection = call.payload.isEmpty ? nil : call.payload
                }
            }
            
            let initialValueJS = initialSelection.map { "\"\($0)\"" } ?? "null"
            try? await self.node.callFunction(runtime: lightpanda, function: #"""
            function() {
                let internalValue = \#(initialValueJS);
                Object.defineProperty(this, "value", {
                    get() { return internalValue; },
                    set(newValue) {
                        internalValue = newValue;
                        globalThis["\#(id)"](newValue ?? "");
                    },
                    configurable: true
                });
            }
            """#)
        }
    }
}
