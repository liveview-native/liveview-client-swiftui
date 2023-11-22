//
//  RotationModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _RotationModifier: ShapeModifier {
    static let name = "rotation"

    let angle: Angle
    let anchor: UnitPoint
    
    init(
        _ angle: Angle,
        anchor: UnitPoint = .center
    ) {
        self.angle = angle
        self.anchor = anchor
    }

    func apply(to shape: AnyShape) -> some SwiftUI.Shape {
        return shape.rotation(angle, anchor: anchor)
    }
}
