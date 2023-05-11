//
//  StrokeModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

struct StrokeModifier: FinalShapeModifier, Decodable {
    let content: AnyShapeStyle
    let style: StrokeStyle?
    
    func apply(to shape: any SwiftUI.Shape) -> some View {
        AnyShape(shape).stroke(content, style: style ?? .init())
    }
    
    func apply(to shape: any InsettableShape) -> some View {
        AnyShape(shape).stroke(content, style: style ?? .init())
    }
}
