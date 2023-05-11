//
//  TrimModifier.swift
//  
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

struct TrimModifier: ShapeModifier, Decodable {
    let startFraction: CGFloat
    let endFraction: CGFloat
    
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
        shape.trim(from: startFraction, to: endFraction)
    }
    
    func apply(to shape: some SwiftUI.InsettableShape) -> any SwiftUI.Shape {
        shape.trim(from: startFraction, to: endFraction)
    }
}
