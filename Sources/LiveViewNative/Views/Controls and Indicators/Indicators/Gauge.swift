//
//  Gauge.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

#if !os(tvOS)
import SwiftUI

struct Gauge<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        Group {
            if context.hasChild(of: element, withTagName: "current-value-label", namespace: "gauge") ||
               context.hasChild(of: element, withTagName: "minimum-value-label", namespace: "gauge") ||
               context.hasChild(of: element, withTagName: "maximum-value-label", namespace: "gauge")
            {
                SwiftUI.Gauge(
                    value: self.value,
                    in: self.lowerBound...self.upperBound
                ) {
                    label
                } currentValueLabel: {
                    context.buildChildren(of: element, withTagName: "current-value-label", namespace: "gauge")
                } minimumValueLabel: {
                    context.buildChildren(of: element, withTagName: "minimum-value-label", namespace: "gauge")
                } maximumValueLabel: {
                    context.buildChildren(of: element, withTagName: "maximum-value-label", namespace: "gauge")
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
    
    private var value: Double { element.attributeValue(for: "value").flatMap(Double.init) ?? 0 }
    private var lowerBound: Double { element.attributeValue(for: "lower-bound").flatMap(Double.init) ?? 0 }
    private var upperBound: Double { element.attributeValue(for: "upper-bound").flatMap(Double.init) ?? 1 }
    private var style: GaugeStyle { element.attributeValue(for: "gauge-style").flatMap(GaugeStyle.init) ?? .automatic }
    
    private var label: some View {
        context.buildChildren(of: element, withTagName: "label", namespace: "gauge", includeDefaultSlot: true)
    }
}

fileprivate enum GaugeStyle: String {
    case accessoryCircularCapacity = "accessory-circular-capacity"
    case accessoryLinearCapacity = "accessory-linear-capacity"
    case accessoryCircular = "accessory-circular"
    case automatic
    case linearCapacity = "linear-capacity"
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
