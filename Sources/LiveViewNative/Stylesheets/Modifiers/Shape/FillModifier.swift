//
//  FillModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/11/25.
//

import SwiftUI
import LiveViewNativeStylesheet

@ASTDecodable("fill")
enum FillModifier: ShapeFinalizerModifier, @preconcurrency Decodable {
    case _content(StylesheetResolvableShapeStyle, style: FillStyle.Resolvable)
    
    init(_ content: StylesheetResolvableShapeStyle, style: FillStyle.Resolvable = .__constant(.init())) {
        self = ._content(content, style: style)
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
            AnyView(shape.fill(content.resolve(on: element, in: context), style: style.resolve(on: element, in: context)))
        }
    }
}
