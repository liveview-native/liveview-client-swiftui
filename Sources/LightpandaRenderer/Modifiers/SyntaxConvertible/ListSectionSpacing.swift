import SwiftUI
import SwiftSyntax

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
@available(iOS 17.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
extension ListSectionSpacing: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle function calls like .custom(10)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text

            if name == "custom",
               let spacing = functionCall.arguments.first.flatMap({ CGFloat(syntax: $0.expression) }) {
                self = .custom(spacing)
                return
            }
        }

        // Handle static properties like .default, .compact
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "default": self = .default
        case "compact": self = .compact
        default: return nil
        }
    }
}
#endif
