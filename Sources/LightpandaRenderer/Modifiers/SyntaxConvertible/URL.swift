import Foundation
import SwiftSyntax

extension URL: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle URL(string: "...") or URL(fileURLWithPath: "...")
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            // Check if this is a URL initializer
            let calledName: String?
            if let declRef = functionCall.calledExpression.as(DeclReferenceExprSyntax.self) {
                calledName = declRef.baseName.text
            } else if let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
                calledName = memberAccess.declName.baseName.text
            } else {
                calledName = nil
            }

            guard calledName == "URL" else { return nil }

            // Try URL(string:)
            if let stringArg = functionCall.arguments.first(where: { $0.label?.text == "string" }),
               let urlString = String(syntax: stringArg.expression),
               let url = URL(string: urlString) {
                self = url
                return
            }

            // Try URL(fileURLWithPath:)
            if let pathArg = functionCall.arguments.first(where: { $0.label?.text == "fileURLWithPath" }),
               let path = String(syntax: pathArg.expression) {
                self = URL(fileURLWithPath: path)
                return
            }

            // Try unlabeled first argument (e.g., URL("https://..."))
            if let firstArg = functionCall.arguments.first,
               firstArg.label == nil,
               let urlString = String(syntax: firstArg.expression),
               let url = URL(string: urlString) {
                self = url
                return
            }
        }

        // Handle simple string literal as URL
        if let urlString = String(syntax: syntax),
           let url = URL(string: urlString) {
            self = url
            return
        }

        return nil
    }
}
