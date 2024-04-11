//
//  ShapeModifier.swift
//
//
//  Created by Carson Katri on 10/31/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// A `ViewModifier` that can be applied directly to `Shape`.
protocol ShapeModifier {
    associatedtype ModifiedShape: SwiftUI.Shape
    
    func apply(to shape: SwiftUI.AnyShape, on element: ElementNode) -> ModifiedShape
}

/// A `ViewModifier` that can be applied directly to `Shape`.
protocol ShapeFinalizerModifier {
    associatedtype FinalizedShape: SwiftUI.View
    
    @ViewBuilder
    func apply(to shape: SwiftUI.AnyShape, on element: ElementNode) -> FinalizedShape
}

extension SwiftUI.Shape {
    func erasedToAnyShape() -> AnyShape {
        AnyShape(self)
    }
}

/// A type-erased `ShapeModifier`, which can be applied to a `View` or directly on `Shape`.
enum _AnyShapeModifier<R: RootRegistry>: ViewModifier, ShapeModifier, ParseableModifierValue {
    case rotation(_RotationModifier)
    case scale(_ScaleModifier<R>)
    case intersection(_IntersectionModifier)
    case union(_UnionModifier)
    case subtracting(_SubtractingModifier)
    case symmetricDifference(_SymmetricDifferenceModifier)
    case lineIntersection(_LineIntersectionModifier)
    case lineSubtraction(_LineSubtractionModifier)
    case transform(_TransformModifier)
    
    func body(content: Content) -> some View {
        content
    }
    
    func apply(to shape: SwiftUI.AnyShape, on element: ElementNode) -> SwiftUI.AnyShape {
        switch self {
        case let .rotation(modifier):
            return modifier.apply(to: shape, on: element).erasedToAnyShape()
        case let .scale(modifier):
            return modifier.apply(to: shape, on: element).erasedToAnyShape()
        case let .intersection(modifier):
            return modifier.apply(to: shape, on: element).erasedToAnyShape()
        case let .union(modifier):
            return modifier.apply(to: shape, on: element).erasedToAnyShape()
        case let .subtracting(modifier):
            return modifier.apply(to: shape, on: element).erasedToAnyShape()
        case let .symmetricDifference(modifier):
            return modifier.apply(to: shape, on: element).erasedToAnyShape()
        case let .lineIntersection(modifier):
            return modifier.apply(to: shape, on: element).erasedToAnyShape()
        case let .lineSubtraction(modifier):
            return modifier.apply(to: shape, on: element).erasedToAnyShape()
        case let .transform(modifier):
            return modifier.apply(to: shape, on: element).erasedToAnyShape()
        }
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            _RotationModifier.parser(in: context).map(Self.rotation)
            _ScaleModifier<R>.parser(in: context).map(Self.scale)
            _IntersectionModifier.parser(in: context).map(Self.intersection)
            _UnionModifier.parser(in: context).map(Self.union)
            _SubtractingModifier.parser(in: context).map(Self.subtracting)
            _SymmetricDifferenceModifier.parser(in: context).map(Self.symmetricDifference)
            _LineIntersectionModifier.parser(in: context).map(Self.lineIntersection)
            _LineSubtractionModifier.parser(in: context).map(Self.lineSubtraction)
            _TransformModifier.parser(in: context).map(Self.transform)
        }
    }
}

/// A type-erased `ShapeFinalizerModifier`, which can be applied to a `View` or directly on `Shape`.
enum _AnyShapeFinalizerModifier<R: RootRegistry>: ViewModifier, ShapeFinalizerModifier, ParseableModifierValue {
    case fill(_FillModifier)
    case stroke(_StrokeModifier<R>)
    
    func body(content: Content) -> some View {
        content
    }
    
    func apply(to shape: SwiftUI.AnyShape, on element: ElementNode) -> some View {
        switch self {
        case let .fill(modifier):
            modifier.apply(to: shape, on: element)
        case let .stroke(modifier):
            modifier.apply(to: shape, on: element)
        }
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            _FillModifier.parser(in: context).map(Self.fill)
            _StrokeModifier<R>.parser(in: context).map(Self.stroke)
        }
    }
}
