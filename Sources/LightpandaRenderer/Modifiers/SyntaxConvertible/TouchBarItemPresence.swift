import SwiftUI
import SwiftSyntax

#if os(macOS)
extension TouchBarItemPresence: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // TouchBarItemPresence is created via static factory methods that take an ID:
        // .default(id), .optional(id), .required(id)
        guard let functionCall = syntax.as(FunctionCallExprSyntax.self),
              let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        // Get the ID argument (first argument)
        guard let idArg = functionCall.arguments.first,
              let id = String(syntax: idArg.expression) else {
            return nil
        }

        switch name {
        case "default": self = .default(id)
        case "optional": self = .optional(id)
        case "required": self = .required(id)
        default: return nil
        }
    }
}
#endif
