import SwiftUI
import SwiftSyntax

extension UnitPoint: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let expr = syntax.as(ExprSyntax.self) else { return nil }
        
        // Handle member access expressions like .center, .topLeading, etc.
        if let memberAccess = expr.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "zero": self = .zero
            case "center": self = .center
            case "leading": self = .leading
            case "trailing": self = .trailing
            case "top": self = .top
            case "bottom": self = .bottom
            case "topLeading": self = .topLeading
            case "topTrailing": self = .topTrailing
            case "bottomLeading": self = .bottomLeading
            case "bottomTrailing": self = .bottomTrailing
            default: return nil
            }
            return
        }
        
        // Handle UnitPoint(x: 0.5, y: 0.5) constructor syntax
        if let funcCall = expr.as(FunctionCallExprSyntax.self) {
            // Check if it's a UnitPoint constructor
            if let calledExpr = funcCall.calledExpression.as(DeclReferenceExprSyntax.self),
               calledExpr.baseName.text == "UnitPoint" {
                guard let x = funcCall.argument(named: "x").flatMap({ CGFloat(syntax: $0.expression) }),
                      let y = funcCall.argument(named: "y").flatMap({ CGFloat(syntax: $0.expression) }) else {
                    return nil
                }
                self = UnitPoint(x: x, y: y)
                return
            }
        }
        
        return nil
    }
}
