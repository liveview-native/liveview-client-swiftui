//
//  Stepper.swift
//  
//
//  Created by Carson Katri on 1/31/23.
//

import SwiftUI
import LightpandaClient

/// A form element for incrementing/decrementing a value in a range.
///
/// This element displays buttons for incrementing/decrementing a value by a ``step`` amount.
///
/// ```html
/// <Stepper value="1">
///     Attendees
/// </Stepper>
/// ```
///
/// Use ``lowerBound`` and ``upperBound`` to limit the value.
/// The ``step`` attribute customizes the amount the value changes.
///
/// ```html
/// <Stepper
///     value="4"
///     lowerBound="0"
///     upperBound="16"
///     step="2"
/// >
///     Attendees
/// </Stepper>
/// ```
///
/// ## Attributes
/// * ``value``
/// * ``step``
/// * ``lowerBound``
/// * ``upperBound``
@_documentation(visibility: public)
struct Stepper<Library: ElementLibrary>: View {
    var node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    /// The current value binding that reads/writes to node.attributes.
    private var value: Binding<Double> {
        Binding(
            get: {
                Double(node.attributes["value"] ?? "") ?? 0
            },
            set: { newValue in
                node.attributes["value"] = String(newValue)
                Task {
                    try? await self.node.callFunction(
                        runtime: lightpanda,
                        function: #"""
                        function() {
                            this.value = \#(newValue);
                            this.dispatchEvent(new Event("input", { bubbles: true }));
                            this.dispatchEvent(new Event("change", { bubbles: true }));
                        }
                        """#
                    )
                }
            }
        )
    }
    
    /// The amount to increment/decrement the value by.
    @_documentation(visibility: public)
    private var step: Double {
        node.attributeValue(for: "step", strategy: .number) ?? 1
    }
    
    /// The lowest allowed value.
    @_documentation(visibility: public)
    private var lowerBound: Double? {
        node.attributeValue(for: "lowerBound", strategy: .number)
    }
    
    /// The highest allowed value.
    @_documentation(visibility: public)
    private var upperBound: Double? {
        node.attributeValue(for: "upperBound", strategy: .number)
    }
    
    public var body: some View {
        #if !os(tvOS)
        SwiftUI.Group {
            if let lowerBound, let upperBound {
                SwiftUI.Stepper(value: value, in: lowerBound...upperBound, step: step) {
                    node.children(library: Library.self)
                }
            } else {
                SwiftUI.Stepper(value: value, step: step) {
                    node.children(library: Library.self)
                }
            }
        }
        .task {
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { [weak node] call in
                guard let node else { return }
                Task { @MainActor in
                    node.attributes["value"] = call.payload
                }
            }
            
            let initialValue = node.attributes["value"] ?? "0"
            try? await self.node.callFunction(runtime: lightpanda, function: #"""
            function() {
                let internalValue = Number("\#(initialValue)");
                Object.defineProperty(this, "value", {
                    get() { return internalValue; },
                    set(newValue) {
                        internalValue = Number(newValue);
                        globalThis["\#(id)"](String(newValue));
                    },
                    configurable: true
                });
            }
            """#)
        }
        #endif
    }
}
