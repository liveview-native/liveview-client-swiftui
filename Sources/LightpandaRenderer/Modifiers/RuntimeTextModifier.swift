import SwiftSyntax
import SwiftUI
import SwiftSyntax

/// Protocol for modifiers that can be applied directly to Text (not just View)
@MainActor
public protocol RuntimeTextModifier {
    /// The base name of the modifier function (e.g., "bold", "italic")
    static var baseName: String { get }
    
    /// Initialize from syntax
    init(syntax: FunctionCallExprSyntax) throws
    
    /// Apply the modifier to Text content
    func textBody(content: SwiftUI.Text) -> SwiftUI.Text
}

/// Type-erased wrapper for RuntimeTextModifier
@MainActor
public struct AnyRuntimeTextModifier {
    private let _textBody: @MainActor @Sendable (Text) -> Text
    
    public init<M: RuntimeTextModifier>(_ modifier: M) {
        let modifier = modifier
        self._textBody = { @MainActor text in modifier.textBody(content: text) }
    }
    
    public func textBody(content: Text) -> Text {
        _textBody(content)
    }
}
