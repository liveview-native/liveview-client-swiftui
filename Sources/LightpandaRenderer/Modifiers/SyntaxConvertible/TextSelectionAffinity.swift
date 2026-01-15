import SwiftUI
import SwiftSyntax

extension TextSelectionAffinity: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "upstream": self = .upstream
        case "downstream": self = .downstream
        default: return nil
        }
    }
}
