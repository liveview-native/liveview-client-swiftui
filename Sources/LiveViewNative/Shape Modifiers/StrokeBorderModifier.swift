//
//  StrokeBorderModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

struct StrokeBorderModifier: FinalShapeModifier, Decodable {
    let content: AnyShapeStyle
    let style: StrokeStyle?
    let antialiased: Bool
    
    func apply(to shape: any SwiftUI.Shape) -> some View {
        AnyShape(shape)
    }
    
    func apply(to shape: any InsettableShape) -> some View {
        AnyView(shape.strokeBorder(content, style: style ?? .init(), antialiased: antialiased))
    }
}
