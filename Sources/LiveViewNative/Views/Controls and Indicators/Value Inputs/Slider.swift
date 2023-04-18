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
/// <Slider value-binding="progress" />
/// ```
///
/// Use ``lowerBound`` and ``upperBound`` to specify the range of possible values.
///
/// ```html
/// <Slider
///     value-binding="progress"
///     lower-bound={-1}
///     upper-bound={2}
/// />
/// ```
///
/// Use the ``step`` attribute to set the distance between valid values.
///
/// ```html
/// <Slider
///     value-binding="progress"
///     lower-bound={0}
///     upper-bound={10}
///     step={1}
/// />
/// ```
///
/// Customize the appearance of the slider with the children `label`, `minimum-value-label` and `maximum-value-label`.
///
/// ```html
/// <Slider value-binding="progress">
///     <Slider:label>Percent Completed</Slider:label>
///     <Slider:minimum-value-label>0%</Slider:minimum-value-label>
///     <Slider:maximum-value-label>100%</Slider:maximum-value-label>
/// </Slider>
/// ```
///
/// ## Attributes
/// * ``lowerBound``
/// * ``upperBound``
/// * ``step``
///
/// ## Children
/// * `label`
/// * `minimum-value-label`
/// * `maximum-value-label`
///
/// ## See Also
/// * [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form)
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Slider<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @FormState(default: 0) var value: Double
    
    /// The lowest allowed value.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("lower-bound") private var lowerBound: Double = 0
    /// The highest allowed value.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("upper-bound") private var upperBound: Double = 1
    /// The distance between allowed values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("step") private var step: Double.Stride?
    
    public var body: some View {
        if let step {
            SwiftUI.Slider(
                value: $value,
                in: lowerBound...upperBound,
                step: step
            ) {
                context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: true)
            } minimumValueLabel: {
                context.buildChildren(of: element, forTemplate: "minimum-value-label")
            } maximumValueLabel: {
                context.buildChildren(of: element, forTemplate: "maximum-value-label")
            }
        } else {
            SwiftUI.Slider(
                value: $value,
                in: lowerBound...upperBound
            ) {
                context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: true)
            } minimumValueLabel: {
                context.buildChildren(of: element, forTemplate: "minimum-value-label")
            } maximumValueLabel: {
                context.buildChildren(of: element, forTemplate: "maximum-value-label")
            }
        }
    }
}
