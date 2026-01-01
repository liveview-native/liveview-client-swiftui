import SwiftUI
import SwiftSyntax

extension Text.Scale: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "default":
                self = .default
            case "secondary":
                self = .secondary
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
