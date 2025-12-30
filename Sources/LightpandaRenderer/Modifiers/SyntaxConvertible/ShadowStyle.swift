import SwiftUI
import SwiftSyntax

extension ShadowStyle: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle function calls like .drop(radius: 5) or .inner(radius: 5)
        guard let functionCall = syntax.as(FunctionCallExprSyntax.self),
              let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) else {
            return nil
        }
        
        let name = memberAccess.declName.baseName.text
        
        // Parse common parameters
        let color: Color = functionCall.argument(named: "color").flatMap { Color(syntax: $0.expression) } ?? .init(.sRGBLinear, white: 0, opacity: 0.33)
        let radius: CGFloat = functionCall.argument(named: "radius").flatMap { CGFloat(syntax: $0.expression) } ?? 0
        let x: CGFloat = functionCall.argument(named: "x").flatMap { CGFloat(syntax: $0.expression) } ?? 0
        let y: CGFloat = functionCall.argument(named: "y").flatMap { CGFloat(syntax: $0.expression) } ?? 0
        
        switch name {
        case "drop":
            self = .drop(color: color, radius: radius, x: x, y: y)
        case "inner":
            self = .inner(color: color, radius: radius, x: x, y: y)
        default:
            return nil
        }
    }
}
