import SwiftUI
import SwiftSyntax

extension CGSize: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle CGSize(width: 100, height: 200) or .init(width: 100, height: 200)
        guard let functionCall = syntax.as(FunctionCallExprSyntax.self) else { return nil }
        
        // Check if it's CGSize(...) or .init(...)
        let isValidCall: Bool
        if let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
            // .init(width:height:)
            isValidCall = memberAccess.declName.baseName.text == "init"
        } else if let declRef = functionCall.calledExpression.as(DeclReferenceExprSyntax.self) {
            // CGSize(width:height:)
            isValidCall = declRef.baseName.text == "CGSize"
        } else {
            isValidCall = false
        }
        
        guard isValidCall else { return nil }
        
        // Extract width and height arguments
        guard let widthArg = functionCall.argument(named: "width"),
              let heightArg = functionCall.argument(named: "height"),
              let width = CGFloat(syntax: widthArg.expression),
              let height = CGFloat(syntax: heightArg.expression)
        else { return nil }
        
        self = CGSize(width: width, height: height)
    }
}
