//
//  ProgressView.swift
//
//
//  Created by Carson Katri on 1/17/23.
//

import SwiftUI

/// Displays progress toward a target value.
///
/// This element can represent a indeterminate spinner in its most basic form.
///
/// ```html
/// <ProgressView />
/// ```
///
/// Use ``value`` and ``total`` to display a specific value.
///
/// ```html
/// <ProgressView value={0.5} />
/// <ProgressView value={0.5} total={2}>
///     <ProgressView:label>Completed Percentage</ProgressView:label>
///     <ProgressView:current-value-label>25%</ProgressView:current-value-label>
/// </ProgressView>
/// ```
///
/// Create a timer with ``timerIntervalStart`` and ``timerIntervalEnd``
///
/// ```html
/// <ProgressView
///     counts-down
///     timer-interval-start={DateTime.utc_now()}
///     timer-interval-end={DateTime.utc_now() |> DateTime.add(5, :minute)}
/// />
/// ```
///
/// ## Attributes
/// * ``value``
/// * ``total``
/// * ``timerIntervalStart``
/// * ``timerIntervalEnd``
/// * ``countsDown``
///
/// ## Children
/// * `label` - Describes the purpose of the element.
/// * `current-value-label` - Describes the current value.
///
/// ## Topics
/// ### Displaying Specific Values
/// - ``value``
/// - ``total``
///
/// ### Creating Timers
/// - ``timerIntervalStart``
/// - ``timerIntervalEnd``
/// - ``countsDown``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ProgressView<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The start date for a timer.
    ///
    /// Expected to be in the ISO8601 format produced by Elixir's `DateTime`.
    ///
    /// This attribute has no effect without ``timerIntervalEnd``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("timer-interval-start") private var timerIntervalStart: Date?
    /// The end date for a timer.
    ///
    /// Expected to be in the ISO8601 format produced by Elixir's `DateTime`.
    ///
    /// This attribute has no effect without ``timerIntervalStart``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("timer-interval-end") private var timerIntervalEnd: Date?
    /// Reverses the direction of a timer progress view.
    ///
    /// This attribute has no effect without ``timerIntervalStart`` and ``timerIntervalEnd``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("counts-down") private var countsDown: Bool
    
    /// Completed amount, out of ``total``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("value") private var value: Double?
    /// The full amount.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("total") private var total: Double = 1
    
    public var body: some View {
        SwiftUI.Group {
            if let timerIntervalStart,
               let timerIntervalEnd
            {
                // SwiftUI's default `currentValueLabel` is not present unless the argument is not included in the initializer.
                // Check if we have it first otherwise use the default.
                if context.hasTemplate(of: element, withName: "current-value-label") {
                    SwiftUI.ProgressView(
                        timerInterval: timerIntervalStart...timerIntervalEnd,
                        countsDown: countsDown
                    ) {
                        context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: true)
                    } currentValueLabel: {
                        context.buildChildren(of: element, forTemplate: "current-value-label")
                    }
                } else {
                    SwiftUI.ProgressView(
                        timerInterval: timerIntervalStart...timerIntervalEnd,
                        countsDown: countsDown
                    ) {
                        context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: true)
                    }
                }
            } else if let value {
                SwiftUI.ProgressView(
                    value: value,
                    total: total
                ) {
                    context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: true)
                } currentValueLabel: {
                    context.buildChildren(of: element, forTemplate: "current-value-label")
                }
            } else {
                SwiftUI.ProgressView {
                    context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: true)
                }
            }
        }
    }
}
