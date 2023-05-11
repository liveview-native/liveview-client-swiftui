//
//  OffsetShapeModifier.swift
//  
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

struct OffsetShapeModifier: ShapeModifier, Decodable {
    let x: CGFloat
    let y: CGFloat
    
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
        shape.offset(x: x, y: y)
    }
    
    func apply(to shape: some SwiftUI.InsettableShape) -> any SwiftUI.Shape {
        shape.offset(x: x, y: y)
    }
}
