//
//  InsetModifier.swift
//  
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

struct InsetModifier: ShapeModifier, Decodable {
    let amount: CGFloat
    
    enum CodingKeys: CodingKey {
        case amount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.amount = try container.decode(CGFloat.self, forKey: .amount)
    }
    
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
        shape
    }
    
    func apply(to shape: some SwiftUI.InsettableShape) -> any SwiftUI.Shape {
        shape.inset(by: amount)
    }
}
