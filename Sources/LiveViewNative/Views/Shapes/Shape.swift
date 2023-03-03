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

    @Attribute("fill-color", transform: { $0?.value.flatMap(SwiftUI.Color.init(fromNamedOrCSSHex:)) }) private var fillColor: SwiftUI.Color?
    @Attribute("stroke-color", transform: { $0?.value.flatMap(SwiftUI.Color.init(fromNamedOrCSSHex:)) }) private var strokeColor: SwiftUI.Color?
    
    init(element: ElementNode, context: LiveContext<some RootRegistry>, shape: S) {
        self.shape = shape
    }
    
    var body: some View {
        if let fillColor {
            shape.fill(fillColor)
        } else if let strokeColor {
            shape.stroke(strokeColor)
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
