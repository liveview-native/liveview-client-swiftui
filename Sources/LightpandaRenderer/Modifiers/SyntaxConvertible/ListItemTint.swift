import SwiftUI
import SwiftSyntax

extension ListItemTint: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle function calls like .fixed(.red) or .preferred(.blue)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text

            if let colorArg = functionCall.arguments.first,
               let color = Color(syntax: colorArg.expression) {
                switch name {
                case "fixed": self = .fixed(color); return
                case "preferred": self = .preferred(color); return
                default: break
                }
            }
        }

        // Handle static properties like .monochrome
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "monochrome": self = .monochrome; return
            default: break
            }
        }

        return nil
    }
}
