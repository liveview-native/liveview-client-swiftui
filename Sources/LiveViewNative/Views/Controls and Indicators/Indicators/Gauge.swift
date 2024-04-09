//
//  Gauge.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import SwiftUI

/// Displays a value within a range.
///
/// Several child elements can be used to customize how ``Gauge`` is displayed.
///
/// ```html
/// <Gauge value="0.5">
///     <Text template="label">50%</Text>
///     <Text template="currentValueLabel">0.5</Text>
///     <Text template="minimumValueLabel">0</Text>
///     <Text template="maximumValueLabel">1</Text>
/// </Gauge>
/// ```
///
/// ## Attributes
/// * ``value``
/// * ``lowerBound``
/// * ``upperBound``
///
/// ## Children
/// * `currentValueLabel` - Describes the current value.
/// * `minimumValueLabel` - Describes the lowest possible value.
/// * `maximumValueLabel` - Describes the highest possible value.
@_documentation(visibility: public)
@LiveElement
struct Gauge<Root: RootRegistry>: View {
    /// The current value of the gauge.
    @_documentation(visibility: public)
    private var value: Double = 0
    /// The lowest possible value of the gauge.
    @_documentation(visibility: public)
    private var lowerBound: Double = 0
    /// The highest possible value of the gauge.
    @_documentation(visibility: public)
    private var upperBound: Double = 1
    
    public var body: some View {
        #if !os(tvOS)
        SwiftUI.Group {
            if $liveElement.hasTemplate("currentValueLabel") ||
                $liveElement.hasTemplate("minimumValueLabel") ||
                $liveElement.hasTemplate("maximumValueLabel")
            {
                SwiftUI.Gauge(
                    value: self.value,
                    in: self.lowerBound...self.upperBound
                ) {
                    $liveElement.children(in: "label", default: true)
                } currentValueLabel: {
                    $liveElement.children(in: "currentValueLabel")
                } minimumValueLabel: {
                    $liveElement.children(in: "minimumValueLabel")
                } maximumValueLabel: {
                    $liveElement.children(in: "maximumValueLabel")
                }
            } else {
                SwiftUI.Gauge(
                    value: value,
                    in: lowerBound...upperBound
                ) {
                    $liveElement.children(in: "label", default: true)
                }
            }
        }
        #endif
    }
}
