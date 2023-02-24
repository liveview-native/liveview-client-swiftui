//
//  Label.swift
//  
//
//  Created by Carson Katri on 1/31/23.
//

import SwiftUI

struct Label<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.Label {
            context.buildChildren(of: element, withTagName: "title", namespace: "label", includeDefaultSlot: true)
        } icon: {
            if let systemImage = element.attributeValue(for: "system-image") {
                SwiftUI.Image(systemName: systemImage)
            } else {
                context.buildChildren(of: element, withTagName: "icon", namespace: "label")
            }
        }
        .applyLabelStyle(element.attributeValue(for: "label-style").flatMap(LabelStyle.init) ?? .automatic)
    }
}

fileprivate enum LabelStyle: String {
    case iconOnly = "icon-only"
    case titleOnly = "title-only"
    case titleAndIcon = "title-and-icon"
    case automatic = "automatic"
}

fileprivate extension View {
    @ViewBuilder
    func applyLabelStyle(_ style: LabelStyle) -> some View {
        switch style {
        case .iconOnly:
            self.labelStyle(.iconOnly)
        case .titleOnly:
            self.labelStyle(.titleOnly)
        case .titleAndIcon:
            self.labelStyle(.titleAndIcon)
        case .automatic:
            self.labelStyle(.automatic)
        }
    }
}
