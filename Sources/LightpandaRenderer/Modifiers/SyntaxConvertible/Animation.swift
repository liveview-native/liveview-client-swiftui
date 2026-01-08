import SwiftUI
import SwiftSyntax

extension Animation: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle simple member access like .default, .easeIn, .easeOut, .easeInOut, .linear
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "default":
                self = .default
            case "easeIn":
                self = .easeIn
            case "easeOut":
                self = .easeOut
            case "easeInOut":
                self = .easeInOut
            case "linear":
                self = .linear
            case "spring":
                self = .spring
            case "bouncy":
                self = .bouncy
            case "smooth":
                self = .smooth
            case "snappy":
                self = .snappy
            case "interactiveSpring":
                self = .interactiveSpring
            default:
                return nil
            }
            return
        }
        
        // Handle function calls like .easeIn(duration: 0.5), .spring(duration: 0.3, bounce: 0.2)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self) {
            if let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
               memberAccess.base == nil {
                let methodName = memberAccess.declName.baseName.text
                
                switch methodName {
                case "easeIn":
                    if let duration = functionCall.argument(named: "duration").flatMap({ Double(syntax: $0.expression) }) {
                        self = .easeIn(duration: duration)
                    } else {
                        self = .easeIn
                    }
                    return
                case "easeOut":
                    if let duration = functionCall.argument(named: "duration").flatMap({ Double(syntax: $0.expression) }) {
                        self = .easeOut(duration: duration)
                    } else {
                        self = .easeOut
                    }
                    return
                case "easeInOut":
                    if let duration = functionCall.argument(named: "duration").flatMap({ Double(syntax: $0.expression) }) {
                        self = .easeInOut(duration: duration)
                    } else {
                        self = .easeInOut
                    }
                    return
                case "linear":
                    if let duration = functionCall.argument(named: "duration").flatMap({ Double(syntax: $0.expression) }) {
                        self = .linear(duration: duration)
                    } else {
                        self = .linear
                    }
                    return
                case "spring":
                    let duration = functionCall.argument(named: "duration").flatMap({ Double(syntax: $0.expression) })
                    let bounce = functionCall.argument(named: "bounce").flatMap({ Double(syntax: $0.expression) })
                    let blendDuration = functionCall.argument(named: "blendDuration").flatMap({ Double(syntax: $0.expression) }) ?? 0
                    
                    if let duration = duration {
                        self = .spring(duration: duration, bounce: bounce ?? 0, blendDuration: blendDuration)
                    } else {
                        self = .spring
                    }
                    return
                case "bouncy":
                    let duration = functionCall.argument(named: "duration").flatMap({ Double(syntax: $0.expression) })
                    let extraBounce = functionCall.argument(named: "extraBounce").flatMap({ Double(syntax: $0.expression) })
                    
                    if let duration = duration, let extraBounce = extraBounce {
                        self = .bouncy(duration: duration, extraBounce: extraBounce)
                    } else if let duration = duration {
                        self = .bouncy(duration: duration)
                    } else {
                        self = .bouncy
                    }
                    return
                case "smooth":
                    let duration = functionCall.argument(named: "duration").flatMap({ Double(syntax: $0.expression) })
                    let extraBounce = functionCall.argument(named: "extraBounce").flatMap({ Double(syntax: $0.expression) })
                    
                    if let duration = duration, let extraBounce = extraBounce {
                        self = .smooth(duration: duration, extraBounce: extraBounce)
                    } else if let duration = duration {
                        self = .smooth(duration: duration)
                    } else {
                        self = .smooth
                    }
                    return
                case "snappy":
                    let duration = functionCall.argument(named: "duration").flatMap({ Double(syntax: $0.expression) })
                    let extraBounce = functionCall.argument(named: "extraBounce").flatMap({ Double(syntax: $0.expression) })
                    
                    if let duration = duration, let extraBounce = extraBounce {
                        self = .snappy(duration: duration, extraBounce: extraBounce)
                    } else if let duration = duration {
                        self = .snappy(duration: duration)
                    } else {
                        self = .snappy
                    }
                    return
                case "interactiveSpring":
                    self = .interactiveSpring
                    return
                default:
                    return nil
                }
            }
        }
        
        return nil
    }
}
