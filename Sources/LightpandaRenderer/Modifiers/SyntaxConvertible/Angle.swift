import SwiftUI
import SwiftSyntax

extension Angle: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle member access like .degrees(90) or .radians(.pi)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            // Check for Angle.degrees(...) or Angle.radians(...) or .degrees(...) or .radians(...)
            let calledExpression = functionCall.calledExpression
            
            var methodName: String?
            
            // Handle .degrees(...) or .radians(...)
            if let memberAccess = calledExpression.as(MemberAccessExprSyntax.self) {
                methodName = memberAccess.declName.baseName.text
            }
            
            if let methodName = methodName {
                // Get the first argument value
                guard let firstArg = functionCall.arguments.first,
                      let value = Double(syntax: firstArg.expression) else {
                    return nil
                }
                
                switch methodName {
                case "degrees":
                    self = .degrees(value)
                    return
                case "radians":
                    self = .radians(value)
                    return
                default:
                    return nil
                }
            }
        }
        
        // Handle Angle(degrees: 90) or Angle(radians: .pi)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            if let degreesArg = functionCall.argument(named: "degrees"),
               let value = Double(syntax: degreesArg.expression) {
                self = .init(degrees: value)
                return
            }
            if let radiansArg = functionCall.argument(named: "radians"),
               let value = Double(syntax: radiansArg.expression) {
                self = .init(radians: value)
                return
            }
        }
        
        return nil
    }
}
