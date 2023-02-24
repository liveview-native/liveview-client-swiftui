//
//  Shape.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct Shape<S: SwiftUI.Shape>: View {
    @ObservedElement private var element: ElementNode
    private let shape: S
    
    init(element: ElementNode, context: LiveContext<some RootRegistry>, shape: S) {
        self.shape = shape
    }
    
    var body: some View {
        if let color = element.attributeValue(for: "fill-color").flatMap(SwiftUI.Color.init(fromNamedOrCSSHex:)) {
            shape.fill(color)
        } else if let color = element.attributeValue(for: "stroke-color").flatMap(SwiftUI.Color.init(fromNamedOrCSSHex:)) {
            shape.stroke(color)
        } else {
            shape
        }
    }
}

extension RoundedRectangle {
    init(from element: ElementNode) {
        let radius = element.attributeValue(for: "corner-radius").flatMap(Double.init) ?? 0
        self.init(
            cornerSize: .init(
                width: element.attributeValue(for: "corner-width").flatMap(Double.init) ?? radius,
                height: element.attributeValue(for: "corner-height").flatMap(Double.init) ?? radius
            ),
            style: (element.attributeValue(for: "style").flatMap(RoundedCornerStyle.init) ?? .circular).style
        )
    }
}

extension Capsule {
    init(from element: ElementNode) {
        self.init(
            style: (element.attributeValue(for: "style").flatMap(RoundedCornerStyle.init) ?? .circular).style
        )
    }
}

private enum RoundedCornerStyle: String {
    case circular
    case continuous
    
    var style: SwiftUI.RoundedCornerStyle {
        switch self {
        case .circular: return .circular
        case .continuous: return .continuous
        }
    }
}
