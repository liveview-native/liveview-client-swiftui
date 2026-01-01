import SwiftSyntax
import SwiftUI

/// Protocol for modifiers that can be applied directly to Shape types (not just View)
@MainActor
public protocol RuntimeShapeModifier {
    /// The base name of the modifier function (e.g., "stroke", "fill")
    static var baseName: String { get }
    
    /// Initialize from syntax
    init(syntax: FunctionCallExprSyntax) throws
    
    /// Apply the modifier to Shape content, returning a View
    func shapeBody<S: SwiftUI.Shape>(content: S) -> AnyView
}

/// Type-erased wrapper for RuntimeShapeModifier
@MainActor
public struct AnyRuntimeShapeModifier {
    private let _shapeBody: @MainActor (any SwiftUI.Shape) -> AnyView
    
    public init<M: RuntimeShapeModifier>(_ modifier: M) {
        self._shapeBody = { @MainActor shape in
            // We need to unwrap the existential and call with concrete type
            @MainActor func apply<S: SwiftUI.Shape>(_ s: S) -> AnyView {
                modifier.shapeBody(content: s)
            }
            return _openExistential(shape, do: apply)
        }
    }
    
    public func shapeBody(content: some SwiftUI.Shape) -> AnyView {
        _shapeBody(content)
    }
}

// Helper to open existential Shape types
@MainActor
private func _openExistential<S: SwiftUI.Shape>(_ shape: S, do body: (S) -> AnyView) -> AnyView {
    body(shape)
}
