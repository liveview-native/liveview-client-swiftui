//
//  LabeledContent.swift
//  
//
//  Created by Carson.Katri on 2/23/23.
//

import SwiftUI

struct LabeledContent<R: CustomRegistry>: View {
    @ObservedElement private var element
    private let context: LiveContext<R>
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        SwiftUI.Group {
            if element.attributeValue(for: "format") != nil {
                SwiftUI.LabeledContent {
                    Text(context: context)
                } label: {
                    context.buildChildren(of: element)
                }
            } else {
                SwiftUI.LabeledContent {
                    context.buildChildren(of: element, withTagName: "content", namespace: "labeled-content", includeDefaultSlot: true)
                } label: {
                    context.buildChildren(of: element, withTagName: "label", namespace: "labeled-content")
                }
            }
        }
        .applyLabeledContentStyle(element.attributeValue(for: "labeled-content-style").flatMap(LabeledContentStyle.init) ?? .automatic)
    }
}

private enum LabeledContentStyle: String {
    case automatic
}

private extension View {
    @ViewBuilder
    func applyLabeledContentStyle(_ style: LabeledContentStyle) -> some View {
        switch style {
        case .automatic: self.labeledContentStyle(.automatic)
        }
    }
}
