//
//  TransformModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _TransformModifier: ShapeModifier {
    static let name = "transform"

    let transform: CGAffineTransform
    
    init(_ transform: CGAffineTransform) {
        self.transform = transform
    }

    func apply(to shape: AnyShape, on element: ElementNode) -> some SwiftUI.Shape {
        return shape.transform(transform)
    }
}
