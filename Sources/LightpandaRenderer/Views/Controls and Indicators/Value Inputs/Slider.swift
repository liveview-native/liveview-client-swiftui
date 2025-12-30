//
//  Slider.swift
//  
//
//  Created by Carson Katri on 1/24/23.
//

import SwiftUI
import LightpandaClient

/// A form element for selecting a value within a range.
///
/// By default, sliders choose values in the range 0-1.
///
/// ```html
/// <Slider value="0.5" />
/// ```
///
/// Use ``lowerBound`` and ``upperBound`` to specify the range of possible values.
///
/// ```html
/// <Slider
///     value="0"
///     lowerBound="-1"
///     upperBound="2"
/// />
/// ```
///
/// Use the ``step`` attribute to set the distance between valid values.
///
/// ```html
/// <Slider
///     value="5"
///     lowerBound="0"
///     upperBound="10"
///     step="1"
/// />
/// ```
///
/// Customize the appearance of the slider with the children `label`, `minimumValueLabel` and `maximumValueLabel`.
///
/// ```html
/// <Slider value="0.5">
///     <Text template="label">Percent Completed</Text>
///     <Text template="minimumValueLabel">0%</Text>
///     <Text template="maximumValueLabel">100%</Text>
/// </Slider>
/// ```
///
/// ## Attributes
/// * ``value``
/// * ``lowerBound``
/// * ``upperBound``
/// * ``step``
///
/// ## Children
/// * `label`
/// * `minimumValueLabel`
/// * `maximumValueLabel`
@_documentation(visibility: public)
struct Slider<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    @State private var value: Double = 0
    
    /// The lowest allowed value.
    @_documentation(visibility: public)
    private var lowerBound: Double {
        node.attributeValue(for: "lowerBound", strategy: .number) ?? 0
    }
    
    /// The highest allowed value.
    @_documentation(visibility: public)
    private var upperBound: Double {
        node.attributeValue(for: "upperBound", strategy: .number) ?? 1
    }
    
    /// The distance between allowed values.
    @_documentation(visibility: public)
    private var step: Double.Stride? {
        node.attributeValue(for: "step", strategy: .number)
    }
    
    /// The initial value.
    @_documentation(visibility: public)
    private var initialValue: Double {
        node.attributeValue(for: "value", strategy: .number) ?? 0
    }
    
    public var body: some View {
        #if !os(tvOS)
        SwiftUI.Group {
            if let step {
                SwiftUI.Slider(
                    value: $value,
                    in: lowerBound...upperBound,
                    step: step
                ) {
                    node.children(in: "label", default: true, library: Library.self)
                } minimumValueLabel: {
                    node.children(in: "minimumValueLabel", library: Library.self)
                } maximumValueLabel: {
                    node.children(in: "maximumValueLabel", library: Library.self)
                }
            } else {
                SwiftUI.Slider(
                    value: $value,
                    in: lowerBound...upperBound
                ) {
                    node.children(in: "label", default: true, library: Library.self)
                } minimumValueLabel: {
                    node.children(in: "minimumValueLabel", library: Library.self)
                } maximumValueLabel: {
                    node.children(in: "maximumValueLabel", library: Library.self)
                }
            }
        }
        .onAppear {
            value = initialValue
        }
        .onChange(of: value) { _, newValue in
            Task {
                try await self.node.callFunction(
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
        .task {
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { call in
                if let newValue = Double(call.payload) {
                    Task { @MainActor in
                        value = newValue
                    }
                }
            }
            
            try? await self.node.callFunction(runtime: lightpanda, function: #"""
            function() {
                let internalValue = \#(initialValue);
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
