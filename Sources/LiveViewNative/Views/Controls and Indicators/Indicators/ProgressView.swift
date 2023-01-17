//
//  Link.swift
//
//
//  Created by Carson Katri on 1/17/23.
//

import SwiftUI

struct ProgressView<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        Group {
            if let timerIntervalStart = element.attributeValue(for: "timer-interval-start").flatMap({ try? ElixirDateParseStrategy().parse($0) }),
               let timerIntervalEnd = element.attributeValue(for: "timer-interval-end").flatMap({ try? ElixirDateParseStrategy().parse($0) })
            {
                // TODO: Note that this variant has a default `currentValueLabel`, which should be used if no current value label slot is used. It seems to only be active when initializing without the `currentValueLabel` argument.
                SwiftUI.ProgressView(
                    timerInterval: timerIntervalStart...timerIntervalEnd,
                    countsDown: element.attributeValue(for: "counts-down") != "false"
                ) {
                    context.buildChildren(of: element)
                }
            } else if let value = element.attributeValue(for: "value").flatMap(Double.init) {
                SwiftUI.ProgressView(
                    value: value,
                    total: element.attributeValue(for: "total").flatMap(Double.init) ?? 1
                ) {
                    context.buildChildren(of: element)
                } currentValueLabel: {
                    EmptyView() // TODO: Implement currentValueLabel once we have a design for multi-body content.
                }
            } else {
                SwiftUI.ProgressView {
                    context.buildChildren(of: element)
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
