import SwiftUI
import SwiftSyntax

/// Modifier for configuring VoiceOver to always include punctuation.
///
/// Usage:
/// ```html
/// <text modifiers="speechAlwaysIncludesPunctuation()">Hello, World!</text>
/// <text modifiers="speechAlwaysIncludesPunctuation(true)">Hello, World!</text>
/// <text modifiers="speechAlwaysIncludesPunctuation(false)">Hello, World!</text>
/// ```
public enum SpeechAlwaysIncludesPunctuationModifier<Library: ElementLibrary>: @unchecked Sendable {
    case speechAlwaysIncludesPunctuation(Bool)
}

extension SpeechAlwaysIncludesPunctuationModifier: RuntimeViewModifier {
    public static var baseName: String { "speechAlwaysIncludesPunctuation" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let value = syntax.arguments.first.flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .speechAlwaysIncludesPunctuation(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .speechAlwaysIncludesPunctuation(let value):
            _content.speechAlwaysIncludesPunctuation(value)
        }
    }
}
