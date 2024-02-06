//
//  Gauge.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import SwiftUI

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
struct Gauge<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The current value of the gauge.
    @_documentation(visibility: public)
    @Attribute("value") private var value: Double = 0
    /// The lowest possible value of the gauge.
    @_documentation(visibility: public)
    @Attribute("lowerBound") private var lowerBound: Double = 0
    /// The highest possible value of the gauge.
    @_documentation(visibility: public)
    @Attribute("upperBound") private var upperBound: Double = 1
    
    public var body: some View {
        #if !os(tvOS)
        SwiftUI.Group {
            if context.hasTemplate(of: element, withName: "currentValueLabel") ||
               context.hasTemplate(of: element, withName: "minimumValueLabel") ||
               context.hasTemplate(of: element, withName: "maximumValueLabel")
            {
                SwiftUI.Gauge(
                    value: self.value,
                    in: self.lowerBound...self.upperBound
                ) {
                    label
                } currentValueLabel: {
                    context.buildChildren(of: element, forTemplate: "currentValueLabel")
                } minimumValueLabel: {
                    context.buildChildren(of: element, forTemplate: "minimumValueLabel")
                } maximumValueLabel: {
                    context.buildChildren(of: element, forTemplate: "maximumValueLabel")
                }
            } else {
                SwiftUI.Gauge(
                    value: value,
                    in: lowerBound...upperBound
                ) {
                    label
                }
            }
        }
        #endif
    }
    
    private var label: some View {
        context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: true)
    }
}
