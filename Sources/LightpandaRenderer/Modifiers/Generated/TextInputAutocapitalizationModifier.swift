import SwiftUI
import SwiftSyntax

/// Modifier for setting text input autocapitalization behavior.
///
/// Usage:
/// ```html
/// <textfield modifiers="textInputAutocapitalization(.never)">
/// <textfield modifiers="textInputAutocapitalization(.words)">
/// <textfield modifiers="textInputAutocapitalization(.sentences)">
/// <textfield modifiers="textInputAutocapitalization(.characters)">
/// ```
#if os(iOS) || os(tvOS) || os(visionOS)
public enum TextInputAutocapitalizationModifier<Library: ElementLibrary>: @unchecked Sendable {
    case textInputAutocapitalization(TextInputAutocapitalization?)
}

extension TextInputAutocapitalizationModifier: RuntimeViewModifier {
    public static var baseName: String { "textInputAutocapitalization" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let value = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil)
            .flatMap({ TextInputAutocapitalization(syntax: $0.expression) })
        self = .textInputAutocapitalization(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .textInputAutocapitalization(let value):
            _content.textInputAutocapitalization(value)
        }
    }
}

extension TextInputAutocapitalization: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "never":
            self = .never
        case "words":
            self = .words
        case "sentences":
            self = .sentences
        case "characters":
            self = .characters
        default:
            return nil
        }
    }
}
#endif
