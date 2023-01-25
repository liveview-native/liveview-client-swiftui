//
//  Slider.swift
//  
//
//  Created by Carson Katri on 1/24/23.
//

import SwiftUI

struct Slider<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    @FormState(default: 0) var value: Double
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        let lowerBound = element.attributeValue(for: "lower-bound").flatMap(Double.init) ?? 0
        let upperBound = element.attributeValue(for: "upper-bound").flatMap(Double.init) ?? 1
        if let step = element.attributeValue(for: "step").flatMap(Double.Stride.init) {
            SwiftUI.Slider(
                value: $value,
                in: lowerBound...upperBound,
                step: step
            ) {
                context.buildChildren(of: element, withTagName: "label", namespace: "slider", includeDefaultSlot: true)
            } minimumValueLabel: {
                context.buildChildren(of: element, withTagName: "minimum-value-label", namespace: "slider")
            } maximumValueLabel: {
                context.buildChildren(of: element, withTagName: "maximum-value-label", namespace: "slider")
            }
        } else {
            SwiftUI.Slider(
                value: $value,
                in: lowerBound...upperBound
            ) {
                context.buildChildren(of: element, withTagName: "label", namespace: "slider", includeDefaultSlot: true)
            } minimumValueLabel: {
                context.buildChildren(of: element, withTagName: "minimum-value-label", namespace: "slider")
            } maximumValueLabel: {
                context.buildChildren(of: element, withTagName: "maximum-value-label", namespace: "slider")
            }
        }
    }
}
