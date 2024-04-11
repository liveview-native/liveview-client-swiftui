//
//  FillModifier.swift
//
//
//  Created by Carson Katri on 10/31/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _FillModifier: ShapeFinalizerModifier {
    static let name = "fill"
    
    let content: AnyShapeStyle
    let style: FillStyle
    
    init(_ content: AnyShapeStyle = .init(.foreground), style: FillStyle = .init()) {
        self.content = content
        self.style = style
    }
    
    @ViewBuilder
    func apply(to shape: AnyShape, on element: ElementNode) -> some View {
        shape.fill(content, style: style)
    }
}
