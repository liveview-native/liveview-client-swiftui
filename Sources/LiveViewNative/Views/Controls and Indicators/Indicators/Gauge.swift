//
//  Gauge.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

#if !os(tvOS)
import SwiftUI

/// Displays a value within a range.
///
/// Several child elements can be used to customize how ``Gauge`` is displayed.
///
/// ```html
/// <Gauge value="0.5">
///     <Gauge:label>50%</Gauge:label>
///     <Gauge:current-value-label>0.5</Gauge:current-value-label>
///     <Gauge:minimum-value-label>0</Gauge:minimum-value-label>
///     <Gauge:maximum-value-label>1</Gauge:maximum-value-label>
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
        SwiftUI.Group {
            if context.hasChild(of: element, withTagName: "current-value-label", namespace: "Gauge") ||
               context.hasChild(of: element, withTagName: "minimum-value-label", namespace: "Gauge") ||
               context.hasChild(of: element, withTagName: "maximum-value-label", namespace: "Gauge")
            {
                SwiftUI.Gauge(
                    value: self.value,
                    in: self.lowerBound...self.upperBound
                ) {
                    label
                } currentValueLabel: {
                    context.buildChildren(of: element, withTagName: "current-value-label", namespace: "Gauge")
                } minimumValueLabel: {
                    context.buildChildren(of: element, withTagName: "minimum-value-label", namespace: "Gauge")
                } maximumValueLabel: {
                    context.buildChildren(of: element, withTagName: "maximum-value-label", namespace: "Gauge")
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
    }
    
    private var label: some View {
        context.buildChildren(of: element, withTagName: "label", namespace: "Gauge", includeDefaultSlot: true)
    }
}
#endif
