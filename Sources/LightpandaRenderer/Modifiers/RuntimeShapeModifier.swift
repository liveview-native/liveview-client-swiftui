//
//  RuntimeShapeModifier.swift
//  LightpandaRenderer
//

import SwiftSyntax
import SwiftUI

/// Result of applying a shape modifier - either preserves Shape type or converts to View
public enum ShapeModifierResult: @unchecked Sendable {
    case shape(any SwiftUI.Shape)
    case view(AnyView)
}

/// Protocol for modifiers that can be applied directly to Shape types
@MainActor
public protocol RuntimeShapeModifier {
    /// The base name of the modifier function (e.g., "stroke", "fill", "trim")
    static var baseName: String { get }
    
    /// Initialize from syntax
    init(syntax: FunctionCallExprSyntax) throws
    
    /// Apply the modifier to Shape content
    /// Returns either a Shape (for chainable modifiers like trim) or a View (for terminal modifiers like fill/stroke)
    func shapeBody<S: SwiftUI.Shape>(content: S) -> ShapeModifierResult
}

/// Type-erased wrapper for RuntimeShapeModifier
@MainActor
public struct AnyRuntimeShapeModifier: @unchecked Sendable {
    private let _shapeBody: @MainActor (any SwiftUI.Shape) -> ShapeModifierResult
    
    public init<M: RuntimeShapeModifier>(_ modifier: M) {
        self._shapeBody = { @MainActor shape in
            @MainActor func apply<S: SwiftUI.Shape>(_ s: S) -> ShapeModifierResult {
                modifier.shapeBody(content: s)
            }
            return _openExistential(shape, do: apply)
        }
    }
    
    public func shapeBody(content: any SwiftUI.Shape) -> ShapeModifierResult {
        _shapeBody(content)
    }
}

// Helper to open existential Shape types
@MainActor
private func _openExistential<S: SwiftUI.Shape>(_ shape: S, do body: (S) -> ShapeModifierResult) -> ShapeModifierResult {
    body(shape)
}
