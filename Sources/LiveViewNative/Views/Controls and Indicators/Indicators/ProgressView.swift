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
///     <Text template={:label}>Completed Percentage</Text>
///     <Text template="currentValueLabel">25%</Text>
/// </ProgressView>
/// ```
///
/// Create a timer with ``timerIntervalStart`` and ``timerIntervalEnd``
///
/// ```html
/// <ProgressView
///     counts-down
///     timerInterval:start={DateTime.utc_now()}
///     timerInterval:end={DateTime.utc_now() |> DateTime.add(5, :minute)}
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
/// * `currentValueLabel` - Describes the current value.
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
@_documentation(visibility: public)
struct ProgressView<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The start date for a timer.
    ///
    /// Expected to be in the ISO8601 format produced by Elixir's `DateTime`.
    ///
    /// This attribute has no effect without ``timerIntervalEnd``.
    @_documentation(visibility: public)
    @Attribute(.init(namespace: "timerInterval", name: "start")) private var timerIntervalStart: Date?
    /// The end date for a timer.
    ///
    /// Expected to be in the ISO8601 format produced by Elixir's `DateTime`.
    ///
    /// This attribute has no effect without ``timerIntervalStart``.
    @_documentation(visibility: public)
    @Attribute(.init(namespace: "timerInterval", name: "end")) private var timerIntervalEnd: Date?
    /// Reverses the direction of a timer progress view.
    ///
    /// This attribute has no effect without ``timerIntervalStart`` and ``timerIntervalEnd``.
    @_documentation(visibility: public)
    @Attribute(.init(name: "countsDown")) private var countsDown: Bool
    
    /// Completed amount, out of ``total``.
    @_documentation(visibility: public)
    @Attribute(.init(name: "value")) private var value: Double?
    /// The full amount.
    @_documentation(visibility: public)
    @Attribute(.init(name: "total")) private var total: Double = 1
    
    public var body: some View {
        SwiftUI.Group {
            if let timerIntervalStart,
               let timerIntervalEnd
            {
                // SwiftUI's default `currentValueLabel` is not present unless the argument is not included in the initializer.
                // Check if we have it first otherwise use the default.
                if context.hasTemplate(of: element, withName: "currentValueLabel") {
                    SwiftUI.ProgressView(
                        timerInterval: timerIntervalStart...timerIntervalEnd,
                        countsDown: countsDown
                    ) {
                        context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: true)
                    } currentValueLabel: {
                        context.buildChildren(of: element, forTemplate: "currentValueLabel")
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
                    context.buildChildren(of: element, forTemplate: "currentValueLabel")
                }
            } else {
                SwiftUI.ProgressView {
                    context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: true)
                }
            }
        }
    }
}
