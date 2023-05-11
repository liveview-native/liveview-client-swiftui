//
//  FillModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

struct FillModifier: FinalShapeModifier, Decodable {
    let content: AnyShapeStyle
    let style: FillStyle?
    
    func apply(to shape: any SwiftUI.Shape) -> some View {
        AnyShape(shape).fill(content, style: style ?? .init())
    }
    
    func apply(to shape: any InsettableShape) -> some View {
        AnyShape(shape).fill(content, style: style ?? .init())
    }
}
