import SwiftUI
import SwiftSyntax

extension RectangleCornerRadii: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let functionCall = syntax.as(FunctionCallExprSyntax.self),
              let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil,
              memberAccess.declName.baseName.text == "init" || functionCall.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text == "RectangleCornerRadii"
        else {
            // Try parsing as DeclReferenceExprSyntax (e.g., RectangleCornerRadii(...))
            if let functionCall = syntax.as(FunctionCallExprSyntax.self),
               let declRef = functionCall.calledExpression.as(DeclReferenceExprSyntax.self),
               declRef.baseName.text == "RectangleCornerRadii" {
                let topLeading: CGFloat = functionCall.argument(named: "topLeading") ?? 0
                let bottomLeading: CGFloat = functionCall.argument(named: "bottomLeading") ?? 0
                let bottomTrailing: CGFloat = functionCall.argument(named: "bottomTrailing") ?? 0
                let topTrailing: CGFloat = functionCall.argument(named: "topTrailing") ?? 0
                
                self.init(
                    topLeading: topLeading,
                    bottomLeading: bottomLeading,
                    bottomTrailing: bottomTrailing,
                    topTrailing: topTrailing
                )
                return
            }
            return nil
        }
        
        let topLeading: CGFloat = functionCall.argument(named: "topLeading") ?? 0
        let bottomLeading: CGFloat = functionCall.argument(named: "bottomLeading") ?? 0
        let bottomTrailing: CGFloat = functionCall.argument(named: "bottomTrailing") ?? 0
        let topTrailing: CGFloat = functionCall.argument(named: "topTrailing") ?? 0
        
        self.init(
            topLeading: topLeading,
            bottomLeading: bottomLeading,
            bottomTrailing: bottomTrailing,
            topTrailing: topTrailing
        )
    }
}
