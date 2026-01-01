import SwiftSyntax
import SwiftUI

/// Protocol for modifiers that can be applied directly to Image (not just View)
@MainActor
public protocol RuntimeImageModifier {
    /// The base name of the modifier function (e.g., "resizable")
    static var baseName: String { get }
    
    /// Initialize from syntax
    init(syntax: FunctionCallExprSyntax) throws
    
    /// Apply the modifier to Image content
    func imageBody(content: SwiftUI.Image) -> SwiftUI.Image
}

/// Type-erased wrapper for RuntimeImageModifier
@MainActor
public struct AnyRuntimeImageModifier {
    private let _imageBody: @MainActor @Sendable (SwiftUI.Image) -> SwiftUI.Image
    
    public init<M: RuntimeImageModifier>(_ modifier: M) {
        let modifier = modifier
        self._imageBody = { @MainActor image in modifier.imageBody(content: image) }
    }
    
    public func imageBody(content: SwiftUI.Image) -> SwiftUI.Image {
        _imageBody(content)
    }
}
