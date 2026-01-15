import SwiftUI
import SwiftSyntax

extension MaterialActiveAppearance: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        #if os(macOS)
        case "inactive": self = .inactive
        #endif
        case "active": self = .active
        default: return nil
        }
    }
}
