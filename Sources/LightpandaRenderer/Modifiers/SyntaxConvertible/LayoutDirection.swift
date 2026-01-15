import SwiftUI
import SwiftSyntax

extension LayoutDirection: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "leftToRight":
            self = .leftToRight
        case "rightToLeft":
            self = .rightToLeft
        default:
            return nil
        }
    }
}
