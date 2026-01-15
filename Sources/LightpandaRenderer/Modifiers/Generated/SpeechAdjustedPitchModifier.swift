import SwiftUI
import SwiftSyntax

/// Modifier for adjusting the speech pitch for VoiceOver.
///
/// Usage:
/// ```html
/// <text modifiers="speechAdjustedPitch(0.5)">Higher pitch</text>
/// <text modifiers="speechAdjustedPitch(-0.5)">Lower pitch</text>
/// ```
public enum SpeechAdjustedPitchModifier<Library: ElementLibrary>: @unchecked Sendable {
    case speechAdjustedPitch(Double)
}

extension SpeechAdjustedPitchModifier: RuntimeViewModifier {
    public static var baseName: String { "speechAdjustedPitch" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let value = syntax.arguments.first.flatMap({ Double(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "SpeechAdjustedPitchModifier", argument: "value")
        }
        self = .speechAdjustedPitch(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .speechAdjustedPitch(let value):
            _content.speechAdjustedPitch(value)
        }
    }
}
