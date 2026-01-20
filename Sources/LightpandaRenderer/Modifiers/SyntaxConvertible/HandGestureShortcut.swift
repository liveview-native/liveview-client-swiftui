import SwiftUI
import SwiftSyntax

#if os(visionOS)
extension HandGestureShortcut: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "primaryAction": self = .primaryAction
        default: return nil
        }
    }
}
#endif
