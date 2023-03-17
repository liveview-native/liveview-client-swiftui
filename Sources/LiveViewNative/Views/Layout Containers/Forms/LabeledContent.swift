//
//  LabeledContent.swift
//  
//
//  Created by Carson.Katri on 2/23/23.
//

import SwiftUI

struct LabeledContent<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    @Attribute("format") private var format: String?
    @Attribute("labeled-content-style") private var style: LabeledContentStyle = .automatic
    
    var body: some View {
        SwiftUI.Group {
            if format != nil {
                SwiftUI.LabeledContent {
                    Text<R>()
                } label: {
                    context.buildChildren(of: element)
                }
            } else {
                SwiftUI.LabeledContent {
                    context.buildChildren(of: element, withTagName: "content", namespace: "LabeledContent", includeDefaultSlot: true)
                } label: {
                    context.buildChildren(of: element, withTagName: "label", namespace: "LabeledContent")
                }
            }
        }
        .applyLabeledContentStyle(style)
    }
}

private enum LabeledContentStyle: String, AttributeDecodable {
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
