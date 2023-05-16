//
//  ShapeModifierProtocol.swift
//  
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

/// A modifier that applies to a ``Shape``.
protocol ShapeModifier {
    @_disfavoredOverload
    /// Modify the `Shape` and return the new erased `Shape` type.
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape
    /// Modify the `InsettableShape` and return the new erased `Shape` type.
    func apply(to shape: some InsettableShape) -> any SwiftUI.Shape
}

extension ShapeModifier {
    /// Applies the modifier to a `Shape` or `InsettableShape` (preferred).
    func apply(to shape: EitherAnyShape) -> EitherAnyShape {
        switch shape {
        case let .shape(shape):
            return .shape(self.apply(to: shape))
        case let .insettable(shape):
            let result = self.apply(to: shape)
            if let insettable = result as? any InsettableShape {
                return .insettable(insettable)
            } else {
                return .shape(result)
            }
        }
    }
}

/// A modifier that applies to a `Shape` and returns a `View`.
protocol FinalShapeModifier {
    associatedtype Body: View
    associatedtype InsettableBody: View
    /// Modify the `Shape` and return the new `View` type.
    @_disfavoredOverload
    func apply(to shape: any SwiftUI.Shape) -> Body
    /// Modify the `InsettableShape` and return the new `View` type.
    func apply(to shape: any SwiftUI.InsettableShape) -> InsettableBody
}

extension FinalShapeModifier {
    /// Applies the modifier to a `Shape` or `InsettableShape` (preferred).
    @ViewBuilder
    func apply(to shape: EitherAnyShape) -> some View {
        switch shape {
        case let .shape(shape):
            self.apply(to: shape)
        case let .insettable(shape):
            self.apply(to: shape)
        }
    }
}

/// An erased `Shape` or `InsettableShape`.
enum EitherAnyShape {
    case shape(any SwiftUI.Shape)
    case insettable(any InsettableShape)
    
    /// Erases the `any Shape` or `any InsettableShape` to an `AnyShape`.
    func eraseToAnyShape() -> AnyShape {
        switch self {
        case let .shape(shape):
            return AnyShape(shape)
        case let .insettable(shape):
            return AnyShape(shape)
        }
    }
}

@resultBuilder
enum FinalShapeModifierBuilder {
    static func buildBlock<M: FinalShapeModifier>(_ component: M) -> M {
        component
    }
    
    static func buildEither<
        TrueShapeModifier: FinalShapeModifier,
        FalseShapeModifier: FinalShapeModifier
    >(first component: @autoclosure () throws -> TrueShapeModifier) rethrows -> _ConditionalFinalShapeModifier<TrueShapeModifier, FalseShapeModifier> {
        .init(storage: .trueContent(try component()))
    }
    static func buildEither<
        TrueShapeModifier: FinalShapeModifier,
        FalseShapeModifier: FinalShapeModifier
    >(second component: @autoclosure () throws -> FalseShapeModifier) rethrows -> _ConditionalFinalShapeModifier<TrueShapeModifier, FalseShapeModifier> {
        .init(storage: .falseContent(try component()))
    }
}

/// A `FinalShapeModifier` that switches between two possible shape modifier types.
struct _ConditionalFinalShapeModifier<TrueContent, FalseContent>: FinalShapeModifier
where TrueContent: FinalShapeModifier, FalseContent: FinalShapeModifier {
    enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }
    
    let storage: Storage
    
    @ViewBuilder
    func apply(to shape: any SwiftUI.Shape) -> some View {
        switch storage {
        case let .trueContent(modifier):
            modifier.apply(to: shape)
        case let .falseContent(modifier):
            modifier.apply(to: shape)
        }
    }
    
    @ViewBuilder
    func apply(to shape: any InsettableShape) -> some View {
        switch storage {
        case let .trueContent(modifier):
            modifier.apply(to: shape)
        case let .falseContent(modifier):
            modifier.apply(to: shape)
        }
    }
}

/// A protocol used by `ShapeModifierRegistry` to provide access to the `AggregateFinalShapeModifier` return type.
protocol ShapeModifierRegistryProtocol {
    associatedtype AggregateFinalShapeModifier: FinalShapeModifier
    
    static func decodeShapeModifier(
        _ type: ShapeModifierType,
        from decoder: Decoder
    ) throws -> ShapeModifier
    
    @FinalShapeModifierBuilder
    static func decodeFinalShapeModifier(
        _ type: FinalShapeModifierType,
        from decoder: Decoder
    ) throws -> AggregateFinalShapeModifier
}

/// Provides helpers for decoding `ShapeModifier` and `FinalShapeModifier`.
enum ShapeModifierRegistry: ShapeModifierRegistryProtocol {
    static func decodeShapeModifier(
        _ type: ShapeModifierType,
        from decoder: Decoder
    ) throws -> ShapeModifier {
        switch type {
        case .inset:
            return try InsetModifier(from: decoder)
        case .offset:
            return try OffsetShapeModifier(from: decoder)
        case .rotation:
            return try RotationModifier(from: decoder)
        case .size:
            return try SizeModifier(from: decoder)
        case .trim:
            return try TrimModifier(from: decoder)
        }
    }
    
    static func decodeFinalShapeModifier(
        _ type: FinalShapeModifierType,
        from decoder: Decoder
    ) throws -> _ConditionalFinalShapeModifier<
        _ConditionalFinalShapeModifier<
            FillModifier,
            StrokeModifier
        >,
        StrokeBorderModifier
    > {
        switch type {
        case .fill:
            try FillModifier(from: decoder)
        case .stroke:
            try StrokeModifier(from: decoder)
        case .strokeBorder:
            try StrokeBorderModifier(from: decoder)
        }
    }
}
