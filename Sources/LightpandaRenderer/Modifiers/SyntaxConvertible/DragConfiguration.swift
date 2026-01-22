import SwiftUI
import SwiftSyntax

#if os(macOS)
@available(macOS 26.0, *)
extension DragConfiguration: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle function call like DragConfiguration(allowMove: true, allowDelete: true)
        // or .init(allowMove: true, allowDelete: true)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            // Check if it's a valid DragConfiguration initializer
            let isInitCall: Bool
            if let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
                isInitCall = memberAccess.declName.baseName.text == "init" ||
                             memberAccess.declName.baseName.text == "DragConfiguration"
            } else if let declRef = functionCall.calledExpression.as(DeclReferenceExprSyntax.self) {
                isInitCall = declRef.baseName.text == "DragConfiguration"
            } else {
                isInitCall = false
            }

            guard isInitCall else { return nil }

            // Try to parse init(allowMove:allowDelete:)
            let allowMove = functionCall.arguments
                .first(where: { $0.label?.text == "allowMove" })
                .flatMap { Bool(syntax: $0.expression) } ?? false

            let allowDelete = functionCall.arguments
                .first(where: { $0.label?.text == "allowDelete" })
                .flatMap { Bool(syntax: $0.expression) } ?? false

            self.init(allowMove: allowMove, allowDelete: allowDelete)
            return
        }

        return nil
    }
}
#endif
