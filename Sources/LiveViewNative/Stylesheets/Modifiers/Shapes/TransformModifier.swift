//
//  TransformModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Shape/transform(_:)`](https://developer.apple.com/documentation/swiftui/shape/transform(_:)) for more details on this ViewModifier.
///
/// ### transform(_:)
/// - `transform`: ``CoreGraphics/CGAffineTransform`` (required)
///
/// See [`SwiftUI.Shape/transform(_:)`](https://developer.apple.com/documentation/swiftui/shape/transform(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   transform(.identity)
/// end
/// ```
@_documentation(visibility: public)
@ASTDecodable("transform")
struct _TransformModifier<Root: RootRegistry>: ShapeModifier {
    let transform: CGAffineTransform
    
    init(_ transform: CGAffineTransform) {
        self.transform = transform
    }

    func apply(to shape: AnyShape, on element: ElementNode, in context: LiveContext<Root>) -> some SwiftUI.Shape {
        return shape.transform(transform)
    }
}
