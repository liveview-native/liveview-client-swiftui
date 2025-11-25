import SwiftUI
import SwiftSyntax

extension FillStyle: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle function call expressions: FillStyle(eoFill: true, antialiased: false)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            // Ensure it's a FillStyle initializer
            guard let calledExpr = functionCall.calledExpression.as(DeclReferenceExprSyntax.self),
                  calledExpr.baseName.text == "FillStyle"
            else { return nil }
            
            let args = functionCall.arguments
            
            // Default values
            var eoFill: Bool = false
            var antialiased: Bool = true
            
            for arg in args {
                let label = arg.label?.text
                
                switch label {
                case "eoFill":
                    if let boolValue = Bool(syntax: arg.expression) {
                        eoFill = boolValue
                    }
                case "antialiased":
                    if let boolValue = Bool(syntax: arg.expression) {
                        antialiased = boolValue
                    }
                default:
                    break
                }
            }
            
            self.init(eoFill: eoFill, antialiased: antialiased)
            return
        }
        
        return nil
    }
}
