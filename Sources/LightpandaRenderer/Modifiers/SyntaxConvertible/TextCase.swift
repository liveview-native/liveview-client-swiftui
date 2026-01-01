import SwiftUI
import SwiftSyntax

extension Text.Case: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "uppercase":
                self = .uppercase
            case "lowercase":
                self = .lowercase
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
