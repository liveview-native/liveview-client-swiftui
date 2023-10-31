//
//  ShapeModifier.swift
//
//
//  Created by Carson Katri on 10/31/23.
//

import SwiftUI

protocol ShapeModifier: ViewModifier where Body == ShapeModifierBody<Self.Content> {
    associatedtype ModifiedShape: SwiftUI.Shape
    
    func apply(to shape: some SwiftUI.Shape) -> ModifiedShape
}

protocol ShapeFinalizerModifier: ViewModifier where Body == ShapeFinalizerModifierBody<Self.Content> {
    associatedtype FinalView: SwiftUI.View
    
    @ViewBuilder
    func apply(to shape: AnyShape) -> FinalView
}

extension ShapeModifier {
    func body(content: Content) -> Body {
        ShapeModifierBody(content: content, modifier: self)
    }
}

extension ShapeFinalizerModifier {
    func body(content: Content) -> Body {
        ShapeFinalizerModifierBody(content: content, modifier: self)
    }
}

struct ShapeModifierBody<Content: View>: View {
    let content: Content
    let modifier: any ShapeModifier
    
    var body: some View {
        content
            .transformEnvironment(\.shapeModifiers) { modifiers in
                modifiers.append(modifier)
            }
    }
}

struct ShapeFinalizerModifierBody<Content: View>: View {
    let content: Content
    let modifier: any ShapeFinalizerModifier
    
    var body: some View {
        content
            .environment(\.shapeFinalizerModifier, modifier)
    }
}

extension EnvironmentValues {
    private enum ShapeModifiersKey: EnvironmentKey {
        static let defaultValue = [any ShapeModifier]()
    }
    
    var shapeModifiers: [any ShapeModifier] {
        get { self[ShapeModifiersKey.self] }
        set { self[ShapeModifiersKey.self] = newValue }
    }
    
    private enum ShapeFinalizerModifierKey: EnvironmentKey {
        static let defaultValue = (any ShapeFinalizerModifier)?.none
    }
    
    var shapeFinalizerModifier: (any ShapeFinalizerModifier)? {
        get { self[ShapeFinalizerModifierKey.self] }
        set { self[ShapeFinalizerModifierKey.self] = newValue }
    }
}

extension SwiftUI.Shape {
    func erasedToAnyShape() -> AnyShape {
        AnyShape(self)
    }
}
