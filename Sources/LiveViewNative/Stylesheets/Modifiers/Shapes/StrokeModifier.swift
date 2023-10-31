//
//  StrokeModifier.swift
//
//
//  Created by Carson Katri on 10/31/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _StrokeModifier: ShapeFinalizerModifier {
    static let name = "stroke"
    
    enum Storage {
        case _0(content: AnyShapeStyle, style: StrokeStyle)
        case _1(content: AnyShapeStyle, lineWidth: CGFloat)
    }
    
    let storage: Storage
    
    init(_ content: AnyShapeStyle, lineWidth: CGFloat = 1) {
        self.storage = ._1(content: content, lineWidth: lineWidth)
    }
    
    @ViewBuilder
    func apply(to shape: AnyShape) -> some View {
        switch storage {
        case ._0(let content, let style):
            shape.stroke(content, style: style)
        case ._1(let content, let lineWidth):
            shape.stroke(content, lineWidth: lineWidth)
        }
    }
}
