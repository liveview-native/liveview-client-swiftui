//
//  RenderingModeModifier.swift
//
//
//  Created by Carson Katri on 11/2/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _RenderingModeModifier: ImageModifier {
    static let name = "renderingMode"
    
    let renderingMode: SwiftUI.Image.TemplateRenderingMode?
    
    init(_ renderingMode: SwiftUI.Image.TemplateRenderingMode?) {
        self.renderingMode = renderingMode
    }
    
    func apply(to image: SwiftUI.Image) -> SwiftUI.Image {
        image.renderingMode(renderingMode)
    }
}

extension SwiftUI.Image.TemplateRenderingMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "template": .template,
            "original": .original,
        ])
    }
}

extension SwiftUI.SymbolRenderingMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "monochrome": .monochrome,
            "multicolor": .multicolor,
            "hierarchical": .hierarchical,
            "palette": .palette,
        ])
    }
}
