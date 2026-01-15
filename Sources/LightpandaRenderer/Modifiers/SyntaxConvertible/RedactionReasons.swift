import SwiftUI
import SwiftSyntax

extension RedactionReasons: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "placeholder": self = .placeholder
        case "privacy": self = .privacy
        case "invalidated": if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            self = .invalidated
        } else {
            return nil
        }
        default: return nil
        }
    }
}
