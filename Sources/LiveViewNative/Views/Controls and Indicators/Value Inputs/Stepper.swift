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
/// <Stepper value="attendees">
///     Attendees
/// </Stepper>
/// ```
///
/// Use ``lowerBound`` and ``upperBound`` to limit the value.
/// The ``step`` attribute customizes the amount the value changes.
///
/// ```html
/// <Stepper
///     value="attendees"
///     lowerBound={0}
///     upperBound={16}
///     step={2}
/// >
///     Attendees
/// </Stepper>
/// ```
///
/// ## Attributes
/// * ``value``
/// * ``step``
/// * ``lowerBound``
/// * ``upperBound``
///
/// ## See Also
/// * [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form)
@_documentation(visibility: public)
@available(iOS 13.0, macOS 10.15, watchOS 9.0, *)
@LiveElement
struct Stepper<Root: RootRegistry>: View {
    @FormState("value", default: 0) var value: Double
    
    /// The amount to increment/decrement the value by.
    @_documentation(visibility: public)
    private var step: Double = 1
    
    /// The lowest allowed value.
    @_documentation(visibility: public)
    private var lowerBound: Double?
    
    /// The highest allowed value.
    @_documentation(visibility: public)
    private var upperBound: Double?
    
    public var body: some View {
        #if !os(tvOS)
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
        #endif
    }
    
    private var label: some View {
        $liveElement.children()
    }
}
