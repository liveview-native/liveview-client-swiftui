import SwiftUI
import SwiftSyntax

extension SwiftUICore.Image.ResizingMode: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let expr = syntax.as(ExprSyntax.self) ?? ExprSyntax(syntax) else {
            return nil
        }
        if let memberAccess = expr.as(MemberAccessExprSyntax.self) {
            let memberName = memberAccess.declName.baseName.text
            switch memberName {
            case "stretch":
                self = .stretch
            case "tile":
                self = .tile
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
