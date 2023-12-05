//
//  ScaleModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _ScaleModifier<R: RootRegistry>: ShapeModifier {
    static var name: String { "scale" }

    enum Value {
        case _0(x: AttributeReference<CGFloat>, y: AttributeReference<CGFloat>, anchor: UnitPoint)
        case _1(scale: CGFloat, anchor: UnitPoint)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    
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

    func apply(to shape: AnyShape) -> some SwiftUI.Shape {
        switch value {
        case let ._0(x, y, anchor):
            return shape.scale(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context), anchor: anchor)
        case let ._1(scale, anchor):
            return shape.scale(scale, anchor: anchor)
        }
    }
}
