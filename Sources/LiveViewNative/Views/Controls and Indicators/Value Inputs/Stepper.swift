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
    
    @Attribute("step") private var step: Double = 1
    @Attribute("lower-bound") private var lowerBound: Double?
    @Attribute("upper-bound") private var upperBound: Double?
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        if let lowerBound,
           let upperBound
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
