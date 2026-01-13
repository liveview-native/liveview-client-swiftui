import SwiftUI
import SwiftSyntax
#if canImport(UIKit)
import UIKit
#endif

/// Modifier for setting text content type hints for text fields.
///
/// Usage:
/// ```html
/// <textfield modifiers="textContentType(.emailAddress)">
/// <textfield modifiers="textContentType(.password)">
/// <textfield modifiers="textContentType(.telephoneNumber)">
/// ```
#if os(iOS) || os(tvOS)
public enum TextContentTypeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case textContentType(UITextContentType?)
}

extension TextContentTypeModifier: RuntimeViewModifier {
    public static var baseName: String { "textContentType" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let value = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil)
            .flatMap({ UITextContentType(syntax: $0.expression) })
        self = .textContentType(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .textContentType(let value):
            _content.textContentType(value)
        }
    }
}

extension UITextContentType: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "name":
            self = .name
        case "namePrefix":
            self = .namePrefix
        case "givenName":
            self = .givenName
        case "middleName":
            self = .middleName
        case "familyName":
            self = .familyName
        case "nameSuffix":
            self = .nameSuffix
        case "nickname":
            self = .nickname
        case "jobTitle":
            self = .jobTitle
        case "organizationName":
            self = .organizationName
        case "location":
            self = .location
        case "fullStreetAddress":
            self = .fullStreetAddress
        case "streetAddressLine1":
            self = .streetAddressLine1
        case "streetAddressLine2":
            self = .streetAddressLine2
        case "addressCity":
            self = .addressCity
        case "addressState":
            self = .addressState
        case "addressCityAndState":
            self = .addressCityAndState
        case "sublocality":
            self = .sublocality
        case "countryName":
            self = .countryName
        case "postalCode":
            self = .postalCode
        case "telephoneNumber":
            self = .telephoneNumber
        case "emailAddress":
            self = .emailAddress
        case "URL":
            self = .URL
        case "creditCardNumber":
            self = .creditCardNumber
        case "username":
            self = .username
        case "password":
            self = .password
        case "newPassword":
            self = .newPassword
        case "oneTimeCode":
            self = .oneTimeCode
        default:
            return nil
        }
    }
}
#endif
