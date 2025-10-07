//
//  ProgressView.swift
//
//
//  Created by Carson Katri on 1/17/23.
//

import SwiftUI
import LightpandaClient

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
struct ProgressView<Library: ElementLibrary>: View {
    let node: Node

    /// The start date for a timer.
    ///
    /// Expected to be in the ISO8601 format produced by Elixir's `DateTime`.
    ///
    /// This attribute has no effect without ``timerIntervalEnd``.
    @_documentation(visibility: public)
    private var timerIntervalStart: Date? {
        node.attributeValue(for: "timerInterval:start", strategy: .dateTime)
    }
    /// The end date for a timer.
    ///
    /// Expected to be in the ISO8601 format produced by Elixir's `DateTime`.
    ///
    /// This attribute has no effect without ``timerIntervalStart``.
    @_documentation(visibility: public)
    private var timerIntervalEnd: Date? {
        node.attributeValue(for: "timerInterval:start", strategy: .dateTime)
    }
    /// Reverses the direction of a timer progress view.
    ///
    /// This attribute has no effect without ``timerIntervalStart`` and ``timerIntervalEnd``.
    @_documentation(visibility: public)
    private var countsDown: Bool {
        node.attributeBoolean(for: "countsDown")
    }
    
    /// Completed amount, out of ``total``.
    @_documentation(visibility: public)
    private var value: Double? {
        node.attributeValue(for: "value", strategy: .number)
    }
    /// The full amount.
    @_documentation(visibility: public)
    private var total: Double {
        node.attributeValue(for: "total", strategy: .number) ?? 1
    }
    
    public var body: some View {
        SwiftUI.Group {
            if let timerIntervalStart,
               let timerIntervalEnd
            {
                // SwiftUI's default `currentValueLabel` is not present unless the argument is not included in the initializer.
                // Check if we have it first otherwise use the default.
                if node.hasTemplate("currentValueLabel") {
                    SwiftUI.ProgressView(
                        timerInterval: timerIntervalStart...timerIntervalEnd,
                        countsDown: countsDown
                    ) {
                        node.children(in: "label", default: true, library: Library.self)
                    } currentValueLabel: {
                        node.children(in: "currentValueLabel", library: Library.self)
                    }
                } else {
                    SwiftUI.ProgressView(
                        timerInterval: timerIntervalStart...timerIntervalEnd,
                        countsDown: countsDown
                    ) {
                        node.children(in: "label", default: true, library: Library.self)
                    }
                }
            } else if let value {
                SwiftUI.ProgressView(
                    value: value,
                    total: total
                ) {
                    node.children(in: "label", default: true, library: Library.self)
                } currentValueLabel: {
                    node.children(in: "currentValueLabel", library: Library.self)
                }
            } else {
                SwiftUI.ProgressView {
                    node.children(in: "label", default: true, library: Library.self)
                }
            }
        }
    }
}
