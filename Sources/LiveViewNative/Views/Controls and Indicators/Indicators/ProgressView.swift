//
//  ProgressView.swift
//
//
//  Created by Carson Katri on 1/17/23.
//

import SwiftUI

struct ProgressView<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    @Attribute("timer-interval-start") private var timerIntervalStart: Date?
    @Attribute("timer-interval-end") private var timerIntervalEnd: Date?
    @Attribute("counts-down") private var countsDown: Bool
    
    @Attribute("value") private var value: Double?
    @Attribute("total") private var total: Double = 1
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
