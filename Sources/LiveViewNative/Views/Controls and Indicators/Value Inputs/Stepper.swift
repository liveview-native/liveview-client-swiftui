//
//  Stepper.swift
//  
//
//  Created by Carson Katri on 1/31/23.
//

import SwiftUI

struct Stepper<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    @FormState(default: 0) var value: Double
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        let step = element.attributeValue(for: "step").flatMap(Double.init) ?? 1
        if let lowerBound = element.attributeValue(for: "lower-bound").flatMap(Double.init),
           let upperBound = element.attributeValue(for: "upper-bound").flatMap(Double.init)
        {
            SwiftUI.Stepper(value: $value, in: lowerBound...upperBound, step: step) {
                label
            }
        } else {
            SwiftUI.Stepper(value: $value, step: step) {
                label
            }
        }
    }
    
    private var label: some View {
        context.buildChildren(of: element)
    }
}
