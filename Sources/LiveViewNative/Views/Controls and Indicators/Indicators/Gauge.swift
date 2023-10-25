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
///     <Text template={:label}>50%</Text>
///     <Text template={:"current-value-label"}>0.5</Text>
///     <Text template={:"minimum-value-label"}>0</Text>
///     <Text template={:"maximum-value-label"}>1</Text>
/// </Gauge>
/// ```
///
/// ## Attributes
/// * ``value``
/// * ``lowerBound``
/// * ``upperBound``
///
/// ## Children
/// * `current-value-label` - Describes the current value.
/// * `minimum-value-label` - Describes the lowest possible value.
/// * `maximum-value-label` - Describes the highest possible value.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Gauge<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The current value of the gauge.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("value") private var value: Double = 0
    /// The lowest possible value of the gauge.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("lower-bound") private var lowerBound: Double = 0
    /// The highest possible value of the gauge.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("upper-bound") private var upperBound: Double = 1
    
    public var body: some View {
        #if !os(tvOS)
        SwiftUI.Group {
            if context.hasTemplate(of: element, withName: "current-value-label") ||
               context.hasTemplate(of: element, withName: "minimum-value-label") ||
               context.hasTemplate(of: element, withName: "maximum-value-label")
            {
                SwiftUI.Gauge(
                    value: self.value,
                    in: self.lowerBound...self.upperBound
                ) {
                    label
                } currentValueLabel: {
                    context.buildChildren(of: element, forTemplate: "current-value-label")
                } minimumValueLabel: {
                    context.buildChildren(of: element, forTemplate: "minimum-value-label")
                } maximumValueLabel: {
                    context.buildChildren(of: element, forTemplate: "maximum-value-label")
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
