import SwiftUI
import SwiftSyntax

#if os(visionOS)
extension OrnamentAttachmentAnchor: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle function call syntax like .scene(.bottom) or .scene(.leading)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            let methodName = memberAccess.declName.baseName.text

            switch methodName {
            case "scene":
                // Parse .scene(.bottom), .scene(.leading), etc.
                if let firstArg = functionCall.arguments.first,
                   let anchorMember = firstArg.expression.as(MemberAccessExprSyntax.self),
                   anchorMember.base == nil {
                    let anchorName = anchorMember.declName.baseName.text
                    switch anchorName {
                    case "bottom":
                        self = .scene(.bottom)
                    case "top":
                        self = .scene(.top)
                    case "leading":
                        self = .scene(.leading)
                    case "trailing":
                        self = .scene(.trailing)
                    case "topLeading":
                        self = .scene(.topLeading)
                    case "topTrailing":
                        self = .scene(.topTrailing)
                    case "bottomLeading":
                        self = .scene(.bottomLeading)
                    case "bottomTrailing":
                        self = .scene(.bottomTrailing)
                    default:
                        return nil
                    }
                    return
                }
            default:
                return nil
            }
        }

        return nil
    }
}
#endif
