//
//  SizeModifier.swift
//  
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

struct SizeModifier: ShapeModifier, Decodable {
    let width: CGFloat
    let height: CGFloat
    
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
        shape.size(width: width, height: height)
    }
    
    func apply(to shape: some SwiftUI.InsettableShape) -> any SwiftUI.Shape {
        shape.size(width: width, height: height)
    }
}
