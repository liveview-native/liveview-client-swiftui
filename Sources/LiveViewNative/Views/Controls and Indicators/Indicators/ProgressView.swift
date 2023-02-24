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
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.Group {
            if let timerIntervalStart = element.attributeValue(for: "timer-interval-start").flatMap({ try? Date($0, strategy: .elixirDateTimeOrDate) }),
               let timerIntervalEnd = element.attributeValue(for: "timer-interval-end").flatMap({ try? Date($0, strategy: .elixirDateTimeOrDate) })
            {
                // SwiftUI's default `currentValueLabel` is not present unless the argument is not included in the initializer.
                // Check if we have it first otherwise use the default.
                if context.hasChild(of: element, withTagName: "current-value-label", namespace: "progress-view") {
                    SwiftUI.ProgressView(
                        timerInterval: timerIntervalStart...timerIntervalEnd,
                        countsDown: element.attributeValue(for: "counts-down") != "false"
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
            } else if let value = element.attributeValue(for: "value").flatMap(Double.init) {
                SwiftUI.ProgressView(
                    value: value,
                    total: element.attributeValue(for: "total").flatMap(Double.init) ?? 1
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
        .applyProgressViewStyle(element.attributeValue(for: "progress-view-style").flatMap(ProgressViewStyle.init) ?? .automatic)
    }
}

fileprivate enum ProgressViewStyle: String {
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
