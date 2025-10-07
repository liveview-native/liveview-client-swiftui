//
//  Gauge.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import SwiftUI
import LightpandaClient

/// Displays a value within a range.
///
/// Several child elements can be used to customize how ``Gauge`` is displayed.
///
/// ```html
/// <Gauge value="0.5">
///     <Text template="label">50%</Text>
///     <Text template="currentValueLabel">0.5</Text>
///     <Text template="minimumValueLabel">0</Text>
///     <Text template="maximumValueLabel">1</Text>
/// </Gauge>
/// ```
///
/// ## Attributes
/// * ``value``
/// * ``lowerBound``
/// * ``upperBound``
///
/// ## Children
/// * `currentValueLabel` - Describes the current value.
/// * `minimumValueLabel` - Describes the lowest possible value.
/// * `maximumValueLabel` - Describes the highest possible value.
@_documentation(visibility: public)
struct Gauge<Library: ElementLibrary>: View {
    let node: Node
    
    /// The current value of the gauge.
    @_documentation(visibility: public)
    private var value: Double {
        node.attributeValue(for: "value", strategy: .number) ?? 0.0
    }
    /// The lowest possible value of the gauge.
    @_documentation(visibility: public)
    private var lowerBound: Double {
        node.attributeValue(for: "lowerBound", strategy: .number) ?? 0.0
    }
    /// The highest possible value of the gauge.
    @_documentation(visibility: public)
    private var upperBound: Double {
        node.attributeValue(for: "upperBound", strategy: .number) ?? 1.0
    }
    
    public var body: some View {
        #if !os(tvOS)
        SwiftUI.Group {
            if node.hasTemplate("currentValueLabel") ||
                node.hasTemplate("minimumValueLabel") ||
                node.hasTemplate("maximumValueLabel")
            {
                SwiftUI.Gauge(
                    value: self.value,
                    in: self.lowerBound...self.upperBound
                ) {
                    node.children(in: "label", default: true, library: Library.self)
                } currentValueLabel: {
                    node.children(in: "currentValueLabel", library: Library.self)
                } minimumValueLabel: {
                    node.children(in: "minimumValueLabel", library: Library.self)
                } maximumValueLabel: {
                    node.children(in: "maximumValueLabel", library: Library.self)
                }
            } else {
                SwiftUI.Gauge(
                    value: value,
                    in: lowerBound...upperBound
                ) {
                    node.children(in: "label", default: true, library: Library.self)
                }
            }
        }
        #endif
    }
}
