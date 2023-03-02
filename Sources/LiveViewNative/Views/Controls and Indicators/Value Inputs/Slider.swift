//
//  Slider.swift
//  
//
//  Created by Carson Katri on 1/24/23.
//

import SwiftUI

struct Slider<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    @FormState(default: 0) var value: Double
    
    @Attribute("lower-bound") private var lowerBound: Double = 0
    @Attribute("upper-bound") private var upperBound: Double = 1
    @Attribute("step") private var step: Double.Stride?
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        if let step {
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
