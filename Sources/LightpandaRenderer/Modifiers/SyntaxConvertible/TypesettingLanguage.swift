import SwiftUI
import SwiftSyntax

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension TypesettingLanguage: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle member access like .automatic
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "automatic":
                self = .automatic
                return
            default:
                return nil
            }
        }

        // Handle function calls like .explicit(Locale.Language("en")) or TypesettingLanguage.explicit("ja")
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            // Get the function name from the member access
            if let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
                let name = memberAccess.declName.baseName.text
                if name == "explicit",
                   let firstArg = functionCall.arguments.first,
                   let language = Locale.Language(syntax: firstArg.expression) {
                    self = .explicit(language)
                    return
                }
            }
        }

        return nil
    }
}
