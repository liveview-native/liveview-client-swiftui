//
//  Slider.swift
//  
//
//  Created by Carson Katri on 1/24/23.
//

import SwiftUI

/// A form element for selecting a value within a range.
///
/// By default, sliders choose values in the range 0-1.
///
/// ```html
/// <Slider value="progress" />
/// ```
///
/// Use ``lowerBound`` and ``upperBound`` to specify the range of possible values.
///
/// ```html
/// <Slider
///     value="progress"
///     lowerBound={-1}
///     upperBound={2}
/// />
/// ```
///
/// Use the ``step`` attribute to set the distance between valid values.
///
/// ```html
/// <Slider
///     value="progress"
///     lowerBound={0}
///     upperBound={10}
///     step={1}
/// />
/// ```
///
/// Customize the appearance of the slider with the children `label`, `minimum-value-label` and `maximum-value-label`.
///
/// ```html
/// <Slider value="value">
///     <Text template="label">Percent Completed</Text>
///     <Text template="minimumValueLabel">0%</Text>
///     <Text template="maximumValueLabel">100%</Text>
/// </Slider>
/// ```
///
/// ## Attributes
/// * ``value``
/// * ``lowerBound``
/// * ``upperBound``
/// * ``step``
///
/// ## Children
/// * `label`
/// * `minimumValueLabel`
/// * `maximumValueLabel`
///
/// ## See Also
/// * [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form)
@_documentation(visibility: public)
@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
struct Slider<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @FormState("value", default: 0) var value: Double
    
    /// The lowest allowed value.
    @_documentation(visibility: public)
    @Attribute(.init(name: "lowerBound")) private var lowerBound: Double = 0
    
    /// The highest allowed value.
    @_documentation(visibility: public)
    @Attribute(.init(name: "upperBound")) private var upperBound: Double = 1
    
    /// The distance between allowed values.
    @_documentation(visibility: public)
    @Attribute(.init(name: "step")) private var step: Double.Stride?
    
    public var body: some View {
        #if !os(tvOS)
        if let step {
            SwiftUI.Slider(
                value: $value,
                in: lowerBound...upperBound,
                step: step
            ) {
                context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: true)
            } minimumValueLabel: {
                context.buildChildren(of: element, forTemplate: "minimumValueLabel")
            } maximumValueLabel: {
                context.buildChildren(of: element, forTemplate: "maximumValueLabel")
            }
        } else {
            SwiftUI.Slider(
                value: $value,
                in: lowerBound...upperBound
            ) {
                context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: true)
            } minimumValueLabel: {
                context.buildChildren(of: element, forTemplate: "minimumValueLabel")
            } maximumValueLabel: {
                context.buildChildren(of: element, forTemplate: "maximumValueLabel")
            }
        }
        #endif
    }
}
