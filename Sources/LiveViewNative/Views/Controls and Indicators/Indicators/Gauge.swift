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
        let lowerBound = element.attributeValue(for: "lower-bound").flatMap(Double.init) ?? 0
        let upperBound = element.attributeValue(for: "upper-bound").flatMap(Double.init) ?? 1
        Group {
            SwiftUI.Gauge(
                value: element.attributeValue(for: "value").flatMap(Double.init) ?? 0,
                in: lowerBound...upperBound
            ) {
                context.buildChildren(of: element, withTagName: "label", namespace: "gauge", includeDefaultSlot: true)
            } currentValueLabel: {
                context.buildChildren(of: element, withTagName: "current-value-label", namespace: "gauge")
            } minimumValueLabel: {
                context.buildChildren(of: element, withTagName: "minimum-value-label", namespace: "gauge")
            } maximumValueLabel: {
                context.buildChildren(of: element, withTagName: "maximum-value-label", namespace: "gauge")
            }
        }
        .applyGaugeStyle(element.attributeValue(for: "gauge-style").flatMap(GaugeStyle.init) ?? .automatic)
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
