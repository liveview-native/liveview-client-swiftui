import SwiftUI
import SwiftSyntax

/// Modifier for controlling text selection behavior.
///
/// Usage:
/// ```html
/// <text modifiers="textSelection(.enabled)">Selectable text</text>
/// <text modifiers="textSelection(.disabled)">Non-selectable text</text>
/// ```
public enum TextSelectionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case textSelectionEnabled
    case textSelectionDisabled
}

extension TextSelectionModifier: RuntimeViewModifier {
    public static var baseName: String { "textSelection" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let selectability = syntax.arguments.first.flatMap({ TextSelectabilityValue(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "TextSelectionModifier", argument: "selectability")
        }
        switch selectability {
        case .enabled: self = .textSelectionEnabled
        case .disabled: self = .textSelectionDisabled
        }
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .textSelectionEnabled:
            _content.textSelection(.enabled)
        case .textSelectionDisabled:
            _content.textSelection(.disabled)
        }
    }
}
