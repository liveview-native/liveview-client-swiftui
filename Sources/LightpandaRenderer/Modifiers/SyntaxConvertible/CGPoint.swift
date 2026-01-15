import SwiftUI
import SwiftSyntax

extension CGPoint: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle CGPoint(x: 10, y: 20) style
        if let call = syntax.as(FunctionCallExprSyntax.self) {
            var x: CGFloat = 0
            var y: CGFloat = 0

            for arg in call.arguments {
                if arg.label?.text == "x", let val = CGFloat(syntax: arg.expression) {
                    x = val
                } else if arg.label?.text == "y", let val = CGFloat(syntax: arg.expression) {
                    y = val
                }
            }
            self = CGPoint(x: x, y: y)
            return
        }
        return nil
    }
}
