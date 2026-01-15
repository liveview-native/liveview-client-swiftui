import SwiftUI
import SwiftSyntax

extension LayoutDirectionBehavior: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }

        switch memberAccess.declName.baseName.text {
        case "fixed":
            self = .fixed
        case "mirrors":
            self = .mirrors
        default:
            return nil
        }
    }
}
