import SwiftUI
import SwiftSyntax

extension EdgeInsets {
    init?(_ expr: ExprSyntax) {
        // Handle EdgeInsets initialization
        // e.g., EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        guard let functionCall = expr.as(FunctionCallExprSyntax.self) else {
            return nil
        }
        
        var top: CGFloat = 0
        var leading: CGFloat = 0
        var bottom: CGFloat = 0
        var trailing: CGFloat = 0
        
        for argument in functionCall.arguments {
            guard let label = argument.label?.text else { continue }
            guard let value = CGFloat(argument.expression) else { continue }
            
            switch label {
            case "top":
                top = value
            case "leading":
                leading = value
            case "bottom":
                bottom = value
            case "trailing":
                trailing = value
            default:
                break
            }
        }
        
        self = EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
}
