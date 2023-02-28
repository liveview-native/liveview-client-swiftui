//
//  Gauge.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

#if !os(tvOS)
import SwiftUI

struct Gauge<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    @Attribute("value") private var value: Double = 0
    @Attribute("lower-bound") private var lowerBound: Double = 0
    @Attribute("upper-bound") private var upperBound: Double = 1
    @Attribute("style") private var style: GaugeStyle = .automatic
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.Group {
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
    
    private var label: some View {
        context.buildChildren(of: element, withTagName: "label", namespace: "gauge", includeDefaultSlot: true)
    }
}

fileprivate enum GaugeStyle: String, AttributeDecodable {
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
