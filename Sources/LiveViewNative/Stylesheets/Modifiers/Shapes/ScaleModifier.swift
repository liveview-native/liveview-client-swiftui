//
//  ScaleModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Shape/scale(x:y:anchor:)`](https://developer.apple.com/documentation/swiftui/shape/scale(x:y:anchor:)) for more details on this ViewModifier.
///
/// ### scale(x:y:anchor:)
/// - `x`: `attr("...")` or ``CoreFoundation/CGFloat``
/// - `y`: `attr("...")` or ``CoreFoundation/CGFloat``
/// - `anchor`: ``SwiftUI/UnitPoint``
///
/// See [`SwiftUI.Shape/scale(x:y:anchor:)`](https://developer.apple.com/documentation/swiftui/shape/scale(x:y:anchor:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element class='scale(x: attr("x"), y: attr("y"), anchor: .center)' x={@x} y={@y} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _ScaleModifier<Root: RootRegistry>: ShapeModifier {
    static var name: String { "scale" }

    enum Value {
        case _0(x: AttributeReference<CGFloat>, y: AttributeReference<CGFloat>, anchor: UnitPoint)
        case _1(scale: CGFloat, anchor: UnitPoint)
    }

    let value: Value
    
    init(
        x: AttributeReference<CGFloat> = .init(storage: .constant(1)),
        y: AttributeReference<CGFloat> = .init(storage: .constant(1)),
        anchor: UnitPoint = .center
    ) {
        self.value = ._0(x: x, y: y, anchor: anchor)
    }
    
    init(_ scale: CGFloat, anchor: UnitPoint) {
        self.value = ._1(scale: scale, anchor: anchor)
    }

    func apply(to shape: AnyShape, on element: ElementNode, in context: LiveContext<Root>) -> some SwiftUI.Shape {
        switch value {
        case let ._0(x, y, anchor):
            return shape.scale(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context), anchor: anchor)
        case let ._1(scale, anchor):
            return shape.scale(scale, anchor: anchor)
        }
    }
}
