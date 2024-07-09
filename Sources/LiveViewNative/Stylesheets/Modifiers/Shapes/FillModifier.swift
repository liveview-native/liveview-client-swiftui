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
@ParseableExpression
struct _FillModifier: ShapeFinalizerModifier {
    static let name = "fill"
    
    let content: AnyShapeStyle.Resolvable
    let style: FillStyle
    
    init(_ content: AnyShapeStyle.Resolvable = .init(.foreground), style: FillStyle = .init()) {
        self.content = content
        self.style = style
    }
    
    @ViewBuilder
    func apply(to shape: AnyShape, on element: ElementNode) -> some View {
        shape.fill(content.resolve(on: element), style: style)
    }
}
