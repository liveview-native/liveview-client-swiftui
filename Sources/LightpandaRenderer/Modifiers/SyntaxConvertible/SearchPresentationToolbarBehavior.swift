import SwiftUI
import SwiftSyntax

extension SwiftUI.SearchPresentationToolbarBehavior: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "avoidHidingContent": self = .avoidHidingContent
        default: return nil
        }
    }
}
