//
//  ShapeBooleanModifiers.swift
//  LightpandaRenderer
//

import SwiftUI
import SwiftSyntax

/// Shape modifier for `union(_ other: T, eoFill: Bool)`
/// Returns a new shape with filled regions in either this shape or the given shape.
enum UnionShapeModifier: RuntimeShapeModifier {
    case union(AnyShape, eoFill: Bool)
    
    static let baseName = "union"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        guard let shapeArg = args.first(where: { $0.label == nil })?.expression,
              let shape = AnyShape(syntax: shapeArg) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "union", argument: "shape")
        }
        
        let eoFill = args.first(where: { $0.label?.text == "eoFill" })
            .flatMap { Bool(syntax: $0.expression) } ?? false
        
        self = .union(shape, eoFill: eoFill)
    }
    
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .union(let other, let eoFill):
            return .shape(AnyShape(content.union(other, eoFill: eoFill)))
        }
    }
}

/// Shape modifier for `intersection(_ other: T, eoFill: Bool)`
/// Returns a new shape with filled regions common to both shapes.
enum IntersectionShapeModifier: RuntimeShapeModifier {
    case intersection(AnyShape, eoFill: Bool)
    
    static let baseName = "intersection"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        guard let shapeArg = args.first(where: { $0.label == nil })?.expression,
              let shape = AnyShape(syntax: shapeArg) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "intersection", argument: "shape")
        }
        
        let eoFill = args.first(where: { $0.label?.text == "eoFill" })
            .flatMap { Bool(syntax: $0.expression) } ?? false
        
        self = .intersection(shape, eoFill: eoFill)
    }
    
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .intersection(let other, let eoFill):
            return .shape(AnyShape(content.intersection(other, eoFill: eoFill)))
        }
    }
}

/// Shape modifier for `subtracting(_ other: T, eoFill: Bool)`
/// Returns a new shape with filled regions from this shape that are not in the given shape.
enum SubtractingShapeModifier: RuntimeShapeModifier {
    case subtracting(AnyShape, eoFill: Bool)
    
    static let baseName = "subtracting"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        guard let shapeArg = args.first(where: { $0.label == nil })?.expression,
              let shape = AnyShape(syntax: shapeArg) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "subtracting", argument: "shape")
        }
        
        let eoFill = args.first(where: { $0.label?.text == "eoFill" })
            .flatMap { Bool(syntax: $0.expression) } ?? false
        
        self = .subtracting(shape, eoFill: eoFill)
    }
    
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .subtracting(let other, let eoFill):
            return .shape(AnyShape(content.subtracting(other, eoFill: eoFill)))
        }
    }
}

/// Shape modifier for `symmetricDifference(_ other: T, eoFill: Bool)`
/// Returns a new shape with filled regions either from this shape or the given shape, but not in both.
enum SymmetricDifferenceShapeModifier: RuntimeShapeModifier {
    case symmetricDifference(AnyShape, eoFill: Bool)
    
    static let baseName = "symmetricDifference"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        guard let shapeArg = args.first(where: { $0.label == nil })?.expression,
              let shape = AnyShape(syntax: shapeArg) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "symmetricDifference", argument: "shape")
        }
        
        let eoFill = args.first(where: { $0.label?.text == "eoFill" })
            .flatMap { Bool(syntax: $0.expression) } ?? false
        
        self = .symmetricDifference(shape, eoFill: eoFill)
    }
    
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .symmetricDifference(let other, let eoFill):
            return .shape(AnyShape(content.symmetricDifference(other, eoFill: eoFill)))
        }
    }
}

/// Shape modifier for `lineIntersection(_ other: T, eoFill: Bool)`
/// Returns a new shape with a line from this shape that overlaps the filled regions of the given shape.
enum LineIntersectionShapeModifier: RuntimeShapeModifier {
    case lineIntersection(AnyShape, eoFill: Bool)
    
    static let baseName = "lineIntersection"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        guard let shapeArg = args.first(where: { $0.label == nil })?.expression,
              let shape = AnyShape(syntax: shapeArg) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "lineIntersection", argument: "shape")
        }
        
        let eoFill = args.first(where: { $0.label?.text == "eoFill" })
            .flatMap { Bool(syntax: $0.expression) } ?? false
        
        self = .lineIntersection(shape, eoFill: eoFill)
    }
    
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .lineIntersection(let other, let eoFill):
            return .shape(AnyShape(content.lineIntersection(other, eoFill: eoFill)))
        }
    }
}

/// Shape modifier for `lineSubtraction(_ other: T, eoFill: Bool)`
/// Returns a new shape with a line from this shape that does not overlap the filled region of the given shape.
enum LineSubtractionShapeModifier: RuntimeShapeModifier {
    case lineSubtraction(AnyShape, eoFill: Bool)
    
    static let baseName = "lineSubtraction"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        guard let shapeArg = args.first(where: { $0.label == nil })?.expression,
              let shape = AnyShape(syntax: shapeArg) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "lineSubtraction", argument: "shape")
        }
        
        let eoFill = args.first(where: { $0.label?.text == "eoFill" })
            .flatMap { Bool(syntax: $0.expression) } ?? false
        
        self = .lineSubtraction(shape, eoFill: eoFill)
    }
    
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult {
        switch self {
        case .lineSubtraction(let other, let eoFill):
            return .shape(AnyShape(content.lineSubtraction(other, eoFill: eoFill)))
        }
    }
}
