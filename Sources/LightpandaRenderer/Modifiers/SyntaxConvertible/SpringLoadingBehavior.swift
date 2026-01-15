#if os(macOS)
import SwiftUI
import SwiftSyntax

extension SpringLoadingBehavior: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "enabled": self = .enabled
        case "disabled": self = .disabled
        default: return nil
        }
    }
}
#endif
