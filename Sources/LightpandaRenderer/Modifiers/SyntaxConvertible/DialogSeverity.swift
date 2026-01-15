import SwiftUI
import SwiftSyntax

extension DialogSeverity: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "standard": self = .standard
        case "critical": self = .critical
        default: return nil
        }
    }
}
