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
/// * ``style``
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
struct ProgressView<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    /// The start date for a timer.
    ///
    /// Expected to be in the ISO8601 format produced by Elixir's `DateTime`.
    ///
    /// This attribute has no effect without ``timerIntervalEnd``.
    @Attribute("timer-interval-start") private var timerIntervalStart: Date?
    /// The end date for a timer.
    ///
    /// Expected to be in the ISO8601 format produced by Elixir's `DateTime`.
    ///
    /// This attribute has no effect without ``timerIntervalStart``.
    @Attribute("timer-interval-end") private var timerIntervalEnd: Date?
    /// Reverses the direction of a timer progress view.
    ///
    /// This attribute has no effect without ``timerIntervalStart`` and ``timerIntervalEnd``.
    @Attribute("counts-down") private var countsDown: Bool
    
    /// Completed amount, out of ``total``.
    @Attribute("value") private var value: Double?
    /// The full amount.
    @Attribute("total") private var total: Double = 1
    /// The style to apply to this progress view.
    @Attribute("progress-view-style") private var style: ProgressViewStyle = .automatic
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.Group {
            if let timerIntervalStart,
               let timerIntervalEnd
            {
                // SwiftUI's default `currentValueLabel` is not present unless the argument is not included in the initializer.
                // Check if we have it first otherwise use the default.
                if context.hasChild(of: element, withTagName: "current-value-label", namespace: "progress-view") {
                    SwiftUI.ProgressView(
                        timerInterval: timerIntervalStart...timerIntervalEnd,
                        countsDown: countsDown
                    ) {
                        context.buildChildren(of: element, withTagName: "label", namespace: "progress-view", includeDefaultSlot: true)
                    } currentValueLabel: {
                        context.buildChildren(of: element, withTagName: "current-value-label", namespace: "progress-view")
                    }
                } else {
                    SwiftUI.ProgressView(
                        timerInterval: timerIntervalStart...timerIntervalEnd,
                        countsDown: element.attributeValue(for: "counts-down") != "false"
                    ) {
                        context.buildChildren(of: element, withTagName: "label", namespace: "progress-view", includeDefaultSlot: true)
                    }
                }
            } else if let value {
                SwiftUI.ProgressView(
                    value: value,
                    total: total
                ) {
                    context.buildChildren(of: element, withTagName: "label", namespace: "progress-view", includeDefaultSlot: true)
                } currentValueLabel: {
                    context.buildChildren(of: element, withTagName: "current-value-label", namespace: "progress-view")
                }
            } else {
                SwiftUI.ProgressView {
                    context.buildChildren(of: element, withTagName: "label", namespace: "progress-view", includeDefaultSlot: true)
                }
            }
        }
        .applyProgressViewStyle(style)
    }
}

fileprivate enum ProgressViewStyle: String, AttributeDecodable {
    case automatic
    case linear
    case circular
}

fileprivate extension View {
    @ViewBuilder
    func applyProgressViewStyle(_ style: ProgressViewStyle) -> some View {
        switch style {
        case .automatic:
            self.progressViewStyle(.automatic)
        case .linear:
            self.progressViewStyle(.linear)
        case .circular:
            self.progressViewStyle(.circular)
        }
    }
}
