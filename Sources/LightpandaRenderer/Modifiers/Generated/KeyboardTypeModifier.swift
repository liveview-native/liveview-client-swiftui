import SwiftUI
import SwiftSyntax
#if canImport(UIKit)
import UIKit
#endif

/// Modifier for setting the keyboard type for text fields.
///
/// Usage:
/// ```html
/// <textfield modifiers="keyboardType(.emailAddress)">
/// <textfield modifiers="keyboardType(.numberPad)">
/// <textfield modifiers="keyboardType(.phonePad)">
/// ```
#if os(iOS) || os(tvOS)
public enum KeyboardTypeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case keyboardType(UIKeyboardType)
}

extension KeyboardTypeModifier: RuntimeViewModifier {
    public static var baseName: String { "keyboardType" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let value = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil)
            .flatMap({ UIKeyboardType(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "KeyboardTypeModifier", argument: "type")
        }
        self = .keyboardType(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .keyboardType(let value):
            _content.keyboardType(value)
        }
    }
}

extension UIKeyboardType: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "default":
            self = .default
        case "asciiCapable":
            self = .asciiCapable
        case "numbersAndPunctuation":
            self = .numbersAndPunctuation
        case "URL":
            self = .URL
        case "numberPad":
            self = .numberPad
        case "phonePad":
            self = .phonePad
        case "namePhonePad":
            self = .namePhonePad
        case "emailAddress":
            self = .emailAddress
        case "decimalPad":
            self = .decimalPad
        case "twitter":
            self = .twitter
        case "webSearch":
            self = .webSearch
        case "asciiCapableNumberPad":
            self = .asciiCapableNumberPad
        default:
            return nil
        }
    }
}
#endif
