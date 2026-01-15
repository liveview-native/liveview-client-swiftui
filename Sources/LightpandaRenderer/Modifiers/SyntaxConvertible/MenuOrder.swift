import SwiftUI
import SwiftSyntax

#if os(iOS)
@available(iOS 16.0, *)
extension MenuOrder: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "priority": self = .priority
        case "fixed": self = .fixed
        default: return nil
        }
    }
}
#elseif os(macOS)
@available(macOS 13.0, *)
extension MenuOrder: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "fixed": self = .fixed
        default: return nil
        }
    }
}
#endif
