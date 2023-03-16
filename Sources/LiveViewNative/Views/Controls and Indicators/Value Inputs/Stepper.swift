//
//  Stepper.swift
//  
//
//  Created by Carson Katri on 1/31/23.
//

import SwiftUI

/// A form element for incrementing/decrementing a value in a range.
///
/// This element displays buttons for incrementing/decrementing a value by a ``step`` amount.
///
///
/// ```html
/// <Stepper value-binding="attendees">
///     Attendees
/// </Stepper>
/// ```
///
/// Use ``lowerBound`` and ``upperBound`` to limit the value.
/// The ``step`` attribute customizes the amount the value changes.
///
/// ```html
/// <Stepper
///     value-binding="attendees"
///     lower-bound={0}
///     upper-bound={16}
///     step={2}
/// >
///     Attendees
/// </Stepper>
/// ```
///
/// ## Attributes
/// * ``step``
/// * ``lowerBound``
/// * ``upperBound``
///
/// ## See Also
/// * [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form)
struct Stepper<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    @FormState(default: 0) var value: Double
    
    /// The amount to increment/decrement the value by.
    @Attribute("step") private var step: Double = 1
    /// The lowest allowed value.
    @Attribute("lower-bound") private var lowerBound: Double?
    /// The highest allowed value.
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
