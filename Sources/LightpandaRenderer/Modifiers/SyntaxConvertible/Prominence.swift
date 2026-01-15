import SwiftUI
import SwiftSyntax

extension Prominence: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "standard": self = .standard
        case "increased": self = .increased
        default: return nil
        }
    }
}
