import SwiftUI
import SwiftSyntax

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension PresentationBackgroundInteraction: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle member access like .automatic, .enabled, .disabled
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "automatic": self = .automatic
            case "enabled": self = .enabled
            case "disabled": self = .disabled
            default: return nil
            }
            return
        }

        // Handle function calls like .enabled(upThrough: .medium)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "enabled":
                // .enabled(upThrough: detent)
                if let upThroughArg = functionCall.argument(named: "upThrough"),
                   let detent = PresentationDetent(syntax: upThroughArg.expression) {
                    self = .enabled(upThrough: detent)
                    return
                }
            default:
                break
            }
        }

        return nil
    }
}
