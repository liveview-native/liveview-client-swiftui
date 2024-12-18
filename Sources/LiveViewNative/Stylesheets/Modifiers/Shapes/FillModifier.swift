//
//  FillModifier.swift
//
//
//  Created by Carson Katri on 10/31/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Shape/fill(_:style:)`](https://developer.apple.com/documentation/swiftui/shape/fill(_:style:)) for more details on this ViewModifier.
///
/// ### fill(_:style:)
/// - `content`: ``SwiftUI/AnyShapeStyle``
/// - `style`: ``SwiftUI/FillStyle``
///
/// See [`SwiftUI.Shape/fill(_:style:)`](https://developer.apple.com/documentation/swiftui/shape/fill(_:style:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   fill(AnyShapeStyle, style: FillStyle)
/// end
/// ```
@_documentation(visibility: public)
@ASTDecodable("fill")
struct _FillModifier<Root: RootRegistry>: ShapeFinalizerModifier {
    let content: AnyShapeStyle.Resolvable
    let style: FillStyle
    
    init(_ content: AnyShapeStyle.Resolvable = .init(.foreground), style: FillStyle = .init()) {
        self.content = content
        self.style = style
    }
    
    @ViewBuilder
    func apply(to shape: AnyShape, on element: ElementNode, in context: LiveContext<Root>) -> some View {
        shape.fill(content.resolve(on: element, in: context), style: style)
    }
}
