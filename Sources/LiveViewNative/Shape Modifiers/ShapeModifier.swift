//
//  ShapeModifierProtocol.swift
//  
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

protocol ShapeModifier {
    @_disfavoredOverload
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape
    func apply(to shape: some SwiftUI.InsettableShape) -> any SwiftUI.Shape
}

extension ShapeModifier {
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

protocol FinalShapeModifier {
    associatedtype Body: View
    associatedtype InsettableBody: View
    @_disfavoredOverload
    func apply(to shape: any SwiftUI.Shape) -> Body
    func apply(to shape: any SwiftUI.InsettableShape) -> InsettableBody
}

extension FinalShapeModifier {
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

enum EitherAnyShape {
    case shape(any SwiftUI.Shape)
    case insettable(any InsettableShape)
    
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
struct ShapeModifierBuilder {
    static func buildBlock(_ component: some ShapeModifier) -> some ShapeModifier {
        component
    }
    
    static func buildEither<
        TrueShapeModifier: ShapeModifier,
        FalseShapeModifier: ShapeModifier
    >(first component: @autoclosure () throws -> TrueShapeModifier) rethrows -> _ConditionalShapeContent<TrueShapeModifier, FalseShapeModifier> {
        .init(storage: .trueContent(try component()))
    }
    static func buildEither<
        TrueShapeModifier: ShapeModifier,
        FalseShapeModifier: ShapeModifier
    >(second component: @autoclosure () throws -> FalseShapeModifier) rethrows -> _ConditionalShapeContent<TrueShapeModifier, FalseShapeModifier> {
        .init(storage: .falseContent(try component()))
    }
}

@resultBuilder
struct FinalShapeModifierBuilder {
    static func buildBlock<M: FinalShapeModifier>(_ component: M) -> M {
        component
    }
    
    static func buildEither<
        TrueShapeModifier: FinalShapeModifier,
        FalseShapeModifier: FinalShapeModifier
    >(first component: @autoclosure () throws -> TrueShapeModifier) rethrows -> _ConditionalShapeContent<TrueShapeModifier, FalseShapeModifier> {
        .init(storage: .trueContent(try component()))
    }
    static func buildEither<
        TrueShapeModifier: FinalShapeModifier,
        FalseShapeModifier: FinalShapeModifier
    >(second component: @autoclosure () throws -> FalseShapeModifier) rethrows -> _ConditionalShapeContent<TrueShapeModifier, FalseShapeModifier> {
        .init(storage: .falseContent(try component()))
    }
}

/// A `ShapeModifier` that switches between two possible shape modifier types.
struct _ConditionalShapeContent<TrueContent, FalseContent> {
    enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }
    
    let storage: Storage
}

extension _ConditionalShapeContent: ShapeModifier
where TrueContent: ShapeModifier, FalseContent: ShapeModifier {
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
        switch storage {
        case let .trueContent(modifier):
            return modifier.apply(to: shape)
        case let .falseContent(modifier):
            return modifier.apply(to: shape)
        }
    }
}

extension _ConditionalShapeContent: FinalShapeModifier
where TrueContent: FinalShapeModifier, FalseContent: FinalShapeModifier {
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

protocol ShapeModifierRegistryProtocol {
    associatedtype AggregateFinalShapeModifier: FinalShapeModifier
    
    @ShapeModifierBuilder
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
    
    @FinalShapeModifierBuilder
    static func decodeFinalShapeModifier(
        _ type: FinalShapeModifierType,
        from decoder: Decoder
    ) throws -> _ConditionalShapeContent<
        _ConditionalShapeContent<
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
