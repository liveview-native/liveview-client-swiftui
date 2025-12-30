import SwiftUI
import SwiftSyntax

extension Gradient.Stop: @retroactive SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Parse Gradient.Stop(color: .red, location: 0.5)
        // or .init(color: .red, location: 0.5)
        guard let functionCall = syntax.as(FunctionCallExprSyntax.self) else {
            return nil
        }
        
        // Check it's a Gradient.Stop or .init call
        let calledExpr = functionCall.calledExpression.description.trimmingCharacters(in: .whitespaces)
        guard calledExpr == "Gradient.Stop" || calledExpr == ".init" else {
            return nil
        }
        
        guard let color: Color = functionCall.argument(named: "color"),
              let location: CGFloat = functionCall.argument(named: "location") else {
            return nil
        }
        
        self.init(color: color, location: location)
    }
}

// Helper to parse arrays of colors or stops
extension Array: @retroactive SyntaxConvertible where Element: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Parse array literal [element1, element2, ...]
        guard let arrayExpr = syntax.as(ArrayExprSyntax.self) else {
            return nil
        }
        
        var result: [Element] = []
        for element in arrayExpr.elements {
            guard let value = Element(syntax: element.expression) else {
                return nil
            }
            result.append(value)
        }
        self = result
    }
}
