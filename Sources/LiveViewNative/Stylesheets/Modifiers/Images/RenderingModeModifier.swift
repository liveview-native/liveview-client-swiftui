//
//  RenderingModeModifier.swift
//
//
//  Created by Carson Katri on 11/2/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Image/renderingMode(_:)`](https://developer.apple.com/documentation/swiftui/image/renderingMode(_:)) for more details on this ViewModifier.
///
/// ### renderingMode(_:)
/// - `renderingMode`: ``SwiftUI/Image/TemplateRenderingMode`` or `nil` (required)
///
/// See [`SwiftUI.Image/renderingMode(_:)`](https://developer.apple.com/documentation/swiftui/image/renderingMode(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   renderingMode(.template)
/// end
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _RenderingModeModifier: ImageModifier {
    static let name = "renderingMode"
    
    let renderingMode: SwiftUI.Image.TemplateRenderingMode?
    
    init(_ renderingMode: SwiftUI.Image.TemplateRenderingMode?) {
        self.renderingMode = renderingMode
    }
    
    func apply(to image: SwiftUI.Image, on element: ElementNode) -> SwiftUI.Image {
        image.renderingMode(renderingMode)
    }
    
    func body(content: Content) -> some View {
        content
    }
}

/// See [`SwiftUI.Image.TemplateRenderingMode`](https://developer.apple.com/documentation/swiftui/Image/TemplateRenderingMode) for more details.
///
/// Possible values:
/// - `.template`
/// - `.original`
@_documentation(visibility: public)
extension SwiftUI.Image.TemplateRenderingMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "template": .template,
            "original": .original,
        ])
    }
}

/// See [`SwiftUI.SymbolRenderingMode`](https://developer.apple.com/documentation/swiftui/SymbolRenderingMode) for more details.
///
/// Possible values:
/// - `.monochrome`
/// - `.multicolor`
/// - `.hierarchical`
/// - `.palette`
@_documentation(visibility: public)
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
