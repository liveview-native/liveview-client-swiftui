//
//  ShapeModifier.swift
//
//
//  Created by Carson Katri on 10/31/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// A `ViewModifier` that can be applied directly to `Shape`.
protocol ShapeModifier<Root> {
    associatedtype Root: RootRegistry
    associatedtype ModifiedShape: SwiftUI.Shape
    
    func apply(to shape: SwiftUI.AnyShape, on element: ElementNode, in context: LiveContext<Root>) -> ModifiedShape
}

/// A `ViewModifier` that can be applied directly to `Shape`.
protocol ShapeFinalizerModifier<Root> {
    associatedtype Root: RootRegistry
    associatedtype FinalizedShape: SwiftUI.View
    
    @ViewBuilder
    func apply(to shape: SwiftUI.AnyShape, on element: ElementNode, in context: LiveContext<Root>) -> FinalizedShape
}

extension SwiftUI.Shape {
    func erasedToAnyShape() -> AnyShape {
        AnyShape(self)
    }
}

/// A type-erased `ShapeModifier`, which can be applied to a `View` or directly on `Shape`.
enum _AnyShapeModifier<Root: RootRegistry>: ViewModifier, ShapeModifier, ParseableModifierValue {
    case rotation(_RotationModifier<Root>)
    case scale(_ScaleModifier<Root>)
    case intersection(_IntersectionModifier<Root>)
    case union(_UnionModifier<Root>)
    case subtracting(_SubtractingModifier<Root>)
    case symmetricDifference(_SymmetricDifferenceModifier<Root>)
    case lineIntersection(_LineIntersectionModifier<Root>)
    case lineSubtraction(_LineSubtractionModifier<Root>)
    case transform(_TransformModifier<Root>)
    
    func body(content: Content) -> some View {
        content
    }
    
    func apply(to shape: SwiftUI.AnyShape, on element: ElementNode, in context: LiveContext<Root>) -> SwiftUI.AnyShape {
        switch self {
        case let .rotation(modifier):
            return modifier.apply(to: shape, on: element, in: context).erasedToAnyShape()
        case let .scale(modifier):
            return modifier.apply(to: shape, on: element, in: context).erasedToAnyShape()
        case let .intersection(modifier):
            return modifier.apply(to: shape, on: element, in: context).erasedToAnyShape()
        case let .union(modifier):
            return modifier.apply(to: shape, on: element, in: context).erasedToAnyShape()
        case let .subtracting(modifier):
            return modifier.apply(to: shape, on: element, in: context).erasedToAnyShape()
        case let .symmetricDifference(modifier):
            return modifier.apply(to: shape, on: element, in: context).erasedToAnyShape()
        case let .lineIntersection(modifier):
            return modifier.apply(to: shape, on: element, in: context).erasedToAnyShape()
        case let .lineSubtraction(modifier):
            return modifier.apply(to: shape, on: element, in: context).erasedToAnyShape()
        case let .transform(modifier):
            return modifier.apply(to: shape, on: element, in: context).erasedToAnyShape()
        }
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            _RotationModifier<Root>.parser(in: context).map(Self.rotation)
            _ScaleModifier<Root>.parser(in: context).map(Self.scale)
            _IntersectionModifier<Root>.parser(in: context).map(Self.intersection)
            _UnionModifier<Root>.parser(in: context).map(Self.union)
            _SubtractingModifier<Root>.parser(in: context).map(Self.subtracting)
            _SymmetricDifferenceModifier<Root>.parser(in: context).map(Self.symmetricDifference)
            _LineIntersectionModifier<Root>.parser(in: context).map(Self.lineIntersection)
            _LineSubtractionModifier<Root>.parser(in: context).map(Self.lineSubtraction)
            _TransformModifier<Root>.parser(in: context).map(Self.transform)
        }
    }
}

/// A type-erased `ShapeFinalizerModifier`, which can be applied to a `View` or directly on `Shape`.
enum _AnyShapeFinalizerModifier<Root: RootRegistry>: ViewModifier, ShapeFinalizerModifier, ParseableModifierValue {
    case fill(_FillModifier<Root>)
    case stroke(_StrokeModifier<Root>)
    
    func body(content: Content) -> some View {
        content
    }
    
    func apply(to shape: SwiftUI.AnyShape, on element: ElementNode, in context: LiveContext<Root>) -> some View {
        switch self {
        case let .fill(modifier):
            modifier.apply(to: shape, on: element, in: context)
        case let .stroke(modifier):
            modifier.apply(to: shape, on: element, in: context)
        }
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            _FillModifier<Root>.parser(in: context).map(Self.fill)
            _StrokeModifier<Root>.parser(in: context).map(Self.stroke)
        }
    }
}
