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
        case _0(content: AnyShapeStyle, style: StrokeStyle, antialiased: Bool)
        case _1(content: AnyShapeStyle, lineWidth: CGFloat, antialiased: Bool)
    }
    
    let storage: Storage
    
    init(_ content: AnyShapeStyle, style: StrokeStyle, antialiased: Bool = true) {
        self.storage = ._0(content: content, style: style, antialiased: antialiased)
    }
    
    init(_ content: AnyShapeStyle, lineWidth: CGFloat = 1, antialiased: Bool = true) {
        self.storage = ._1(content: content, lineWidth: lineWidth, antialiased: antialiased)
    }
    
    @ViewBuilder
    func apply(to shape: AnyShape) -> some View {
        switch storage {
        case ._0(let content, let style, let antialiased):
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                shape.stroke(content, style: style, antialiased: antialiased)
            } else {
                shape.stroke(content, style: style)
            }
        case ._1(let content, let lineWidth, let antialiased):
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                shape.stroke(content, lineWidth: lineWidth, antialiased: antialiased)
            } else {
                shape.stroke(content, lineWidth: lineWidth)
            }
        }
    }
}

extension StrokeStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableStrokeStyle.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseableStrokeStyle {
        static let name = "StrokeStyle"
        
        let value: StrokeStyle
        
        init(lineWidth: CGFloat = 1, lineCap: CGLineCap = .butt, lineJoin: CGLineJoin = .miter, miterLimit: CGFloat = 10, dash: [CGFloat] = [CGFloat](), dashPhase: CGFloat = 0) {
            self.value = .init(lineWidth: lineWidth, lineCap: lineCap, lineJoin: lineJoin, miterLimit: miterLimit, dash: dash, dashPhase: dashPhase)
        }
    }
}

extension CGLineCap: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "butt": .butt,
            "round": .round,
            "square": .square,
        ])
    }
}

extension CGLineJoin: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "miter": .miter,
            "round": .round,
            "bevel": .bevel,
        ])
    }
}
