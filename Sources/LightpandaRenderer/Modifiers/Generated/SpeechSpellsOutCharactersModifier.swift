import SwiftUI
import SwiftSyntax

/// Modifier for configuring VoiceOver to spell out characters.
///
/// Usage:
/// ```html
/// <text modifiers="speechSpellsOutCharacters()">ABC</text>
/// <text modifiers="speechSpellsOutCharacters(true)">ABC</text>
/// <text modifiers="speechSpellsOutCharacters(false)">ABC</text>
/// ```
public enum SpeechSpellsOutCharactersModifier<Library: ElementLibrary>: @unchecked Sendable {
    case speechSpellsOutCharacters(Bool)
}

extension SpeechSpellsOutCharactersModifier: RuntimeViewModifier {
    public static var baseName: String { "speechSpellsOutCharacters" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let value = syntax.arguments.first.flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .speechSpellsOutCharacters(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .speechSpellsOutCharacters(let value):
            _content.speechSpellsOutCharacters(value)
        }
    }
}
