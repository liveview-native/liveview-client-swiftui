//
//  RotationModifier.swift
//
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

struct RotationModifier: ShapeModifier, Decodable {
    let angle: Angle
    let anchor: UnitPoint?
    
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
        shape.rotation(angle, anchor: anchor ?? .center)
    }
    
    func apply(to shape: some SwiftUI.InsettableShape) -> any SwiftUI.Shape {
        shape.rotation(angle, anchor: anchor ?? .center)
    }
}
