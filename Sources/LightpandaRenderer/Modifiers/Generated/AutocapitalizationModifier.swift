import SwiftUI
import SwiftSyntax
#if canImport(UIKit)
import UIKit
#endif

/// Modifier for setting autocapitalization on text fields.
/// Note: This modifier is deprecated. Use textInputAutocapitalization() instead.
///
/// Usage:
/// ```html
/// <textfield modifiers="autocapitalization(.none)">
/// <textfield modifiers="autocapitalization(.words)">
/// <textfield modifiers="autocapitalization(.sentences)">
/// <textfield modifiers="autocapitalization(.allCharacters)">
/// ```
#if os(iOS) || os(tvOS) || os(visionOS)
public enum AutocapitalizationModifier<Library: ElementLibrary>: @unchecked Sendable {
    case autocapitalization(UITextAutocapitalizationType)
}

extension AutocapitalizationModifier: RuntimeViewModifier {
    public static var baseName: String { "autocapitalization" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let value = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil)
            .flatMap({ UITextAutocapitalizationType(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "AutocapitalizationModifier", argument: "style")
        }
        self = .autocapitalization(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .autocapitalization(let value):
            _content.autocapitalization(value)
        }
    }
}

extension UITextAutocapitalizationType: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "none":
            self = .none
        case "words":
            self = .words
        case "sentences":
            self = .sentences
        case "allCharacters":
            self = .allCharacters
        default:
            return nil
        }
    }
}
#endif
