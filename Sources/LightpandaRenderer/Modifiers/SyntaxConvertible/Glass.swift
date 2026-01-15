import SwiftUI
import SwiftSyntax

// MARK: - Glass

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension Glass: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle simple member access like .regular, .clear, .identity
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "clear":
                self = .clear
            case "identity":
                self = .identity
            case "regular":
                self = .regular
            default:
                return nil
            }
            return
        }
        
        // Handle function calls like .regular.tint(.blue) or .regular.interactive(true)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            // Get the base glass and the method being called
            if let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
                let methodName = memberAccess.declName.baseName.text
                
                // Parse the base glass (e.g., .regular from .regular.tint(...))
                guard let base = memberAccess.base,
                      var glass = Glass(syntax: base) else {
                    return nil
                }
                
                switch methodName {
                case "tint":
                    // .tint(Color?) -> Glass
                    if let colorArg = functionCall.arguments.first?.expression,
                       let color = Color(syntax: colorArg) {
                        glass = glass.tint(color)
                    } else if functionCall.arguments.first?.expression.as(NilLiteralExprSyntax.self) != nil {
                        glass = glass.tint(nil)
                    } else {
                        return nil
                    }
                case "interactive":
                    // .interactive(Bool) -> Glass
                    if let boolArg = functionCall.arguments.first?.expression,
                       let isInteractive = Bool(syntax: boolArg) {
                        glass = glass.interactive(isInteractive)
                    } else {
                        return nil
                    }
                default:
                    return nil
                }
                
                self = glass
                return
            }
        }
        
        return nil
    }
}

// MARK: - GlassEffectTransition

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension GlassEffectTransition: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle simple member access like .identity
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else {
            return nil
        }

        switch memberAccess.declName.baseName.text {
        case "identity": self = .identity
        default: return nil
        }
    }
}
#endif
