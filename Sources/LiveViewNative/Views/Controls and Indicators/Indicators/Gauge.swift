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
/// * ``style``
///
/// ## Children
/// * `current-value-label` - Describes the current value.
/// * `minimum-value-label` - Describes the lowest possible value.
/// * `maximum-value-label` - Describes the highest possible value.
struct Gauge<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    /// The current value of the gauge.
    @Attribute("value") private var value: Double = 0
    /// The lowest possible value of the gauge.
    @Attribute("lower-bound") private var lowerBound: Double = 0
    /// The highest possible value of the gauge.
    @Attribute("upper-bound") private var upperBound: Double = 1
    /// The style to apply to this gauge.
    @Attribute("gauge-style") private var style: GaugeStyle = .automatic
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
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
        .applyGaugeStyle(style)
    }
    
    private var label: some View {
        context.buildChildren(of: element, withTagName: "label", namespace: "Gauge", includeDefaultSlot: true)
    }
}

/// A style for a ``Gauge`` element.
fileprivate enum GaugeStyle: String, AttributeDecodable {
    /// `accessory-circular-capacity`
    case accessoryCircularCapacity = "accessory-circular-capacity"
    /// `accessory-linear-capacity`
    case accessoryLinearCapacity = "accessory-linear-capacity"
    /// `accessory-circular`
    case accessoryCircular = "accessory-circular"
    case automatic
    /// `linear-capacity`
    case linearCapacity = "linear-capacity"
    /// `accessory-linear`
    case accessoryLinear = "accessory-linear"
}

fileprivate extension View {
    @ViewBuilder
    func applyGaugeStyle(_ style: GaugeStyle) -> some View {
        switch style {
        case .accessoryCircularCapacity:
            self.gaugeStyle(.accessoryCircularCapacity)
        case .accessoryLinearCapacity:
            self.gaugeStyle(.accessoryLinearCapacity)
        case .accessoryCircular:
            self.gaugeStyle(.accessoryCircular)
        case .automatic:
            self.gaugeStyle(.automatic)
        case .linearCapacity:
            self.gaugeStyle(.linearCapacity)
        case .accessoryLinear:
            self.gaugeStyle(.accessoryLinear)
        }
    }
}
#endif
