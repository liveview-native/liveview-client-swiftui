import SwiftUI
import SwiftSyntax

/// Modifier for setting the submit button label on text fields.
///
/// Usage:
/// ```html
/// <textfield modifiers="submitLabel(.done)">
/// <textfield modifiers="submitLabel(.go)">
/// <textfield modifiers="submitLabel(.search)">
/// <textfield modifiers="submitLabel(.send)">
/// ```
public enum SubmitLabelModifier<Library: ElementLibrary>: @unchecked Sendable {
    case submitLabel(SubmitLabel)
}

extension SubmitLabelModifier: RuntimeViewModifier {
    public static var baseName: String { "submitLabel" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let value = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil)
            .flatMap({ SubmitLabel(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "SubmitLabelModifier", argument: "submitLabel")
        }
        self = .submitLabel(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .submitLabel(let value):
            _content.submitLabel(value)
        }
    }
}

extension SubmitLabel: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "done":
            self = .done
        case "go":
            self = .go
        case "send":
            self = .send
        case "join":
            self = .join
        case "route":
            self = .route
        case "search":
            self = .search
        case "return":
            self = .return
        case "next":
            self = .next
        case "continue":
            self = .continue
        default:
            return nil
        }
    }
}
