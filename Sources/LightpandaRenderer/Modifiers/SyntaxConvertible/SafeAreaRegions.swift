import SwiftUI
import SwiftSyntax

extension SafeAreaRegions: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "all": self = .all
        case "container": self = .container
        case "keyboard": self = .keyboard
        default: return nil
        }
    }
}
