//
//  StrokeModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/11/25.
//

import SwiftUI
import LiveViewNativeStylesheet

@ASTDecodable("stroke")
enum StrokeModifier: ShapeFinalizerModifier, @preconcurrency Decodable {
    case _content(StylesheetResolvableShapeStyle, style: StrokeStyle.Resolvable)
    case _style(StrokeStyle.Resolvable)
    case _lineWidth(StylesheetResolvableShapeStyle, lineWidth: CGFloat.Resolvable, antialiased: AttributeReference<Bool>)
    
    init(_ content: StylesheetResolvableShapeStyle = .semantic(.foreground), style: StrokeStyle.Resolvable) {
        self = ._content(content, style: style)
    }
    
    init(style: StrokeStyle.Resolvable) {
        self = ._style(style)
    }
    
    init(_ content: StylesheetResolvableShapeStyle, lineWidth: CGFloat.Resolvable = .__constant(1), antialiased: AttributeReference<Bool> = .constant(true)) {
        self = ._lineWidth(content, lineWidth: lineWidth, antialiased: antialiased)
    }
    
    func body(content: Content) -> some View {
        content
    }
    
    func apply<R: RootRegistry>(
        to shape: AnyShape,
        on element: ElementNode,
        in context: LiveContext<R>
    ) -> AnyView {
        switch self {
        case let ._content(content, style):
            AnyView(shape.stroke(content.resolve(on: element, in: context), style: style.resolve(on: element, in: context)))
        case let ._style(style):
            AnyView(shape.stroke(style: style.resolve(on: element, in: context)))
        case let ._lineWidth(content, lineWidth, antialiased):
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                AnyView(shape.stroke(
                    content.resolve(on: element, in: context),
                    lineWidth: lineWidth.resolve(on: element, in: context),
                    antialiased: antialiased.resolve(on: element, in: context)
                ))
            } else {
                AnyView(shape.stroke(
                    content.resolve(on: element, in: context),
                    lineWidth: lineWidth.resolve(on: element, in: context)
                ))
            }
        }
    }
}
