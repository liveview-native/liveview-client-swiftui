import SwiftUI
import SwiftSyntax

/// Modifier for redacting content.
///
/// Usage:
/// ```html
/// <text modifiers="redacted(reason: .placeholder)">
/// <text modifiers="redacted(reason: .privacy)">
/// ```
public enum RedactedModifier<Library: ElementLibrary>: @unchecked Sendable {
    case redacted(reason: RedactionReasons)
}

extension RedactedModifier: RuntimeViewModifier {
    public static var baseName: String { "redacted" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let reason = syntax.argument(named: "reason").flatMap({ RedactionReasons(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "RedactedModifier", argument: "reason")
        }
        self = .redacted(reason: reason)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .redacted(let reason):
            _content.redacted(reason: reason)
        }
    }
}
