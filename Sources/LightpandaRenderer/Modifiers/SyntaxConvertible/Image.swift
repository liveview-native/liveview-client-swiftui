import SwiftUI
import SwiftSyntax

extension SwiftUICore.Image: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle function call expressions (e.g., Image(systemName: "star"), Image("assetName"))
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            // Ensure it's an Image initializer
            guard let calledExpr = functionCall.calledExpression.as(DeclReferenceExprSyntax.self),
                  calledExpr.baseName.text == "Image"
            else { return nil }

            let args = functionCall.arguments

            // Image(systemName: String)
            if let systemNameArg = args.first(where: { $0.label?.text == "systemName" }),
               let stringLiteral = systemNameArg.expression.as(StringLiteralExprSyntax.self),
               let systemName = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text {
                self = Image(systemName: systemName)
                return
            }

            // Image(_ name: String) - named asset
            if args.count >= 1,
               let firstArg = args.first,
               firstArg.label == nil,
               let stringLiteral = firstArg.expression.as(StringLiteralExprSyntax.self),
               let assetName = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text {
                self = Image(assetName)
                return
            }
        }

        return nil
    }
}
