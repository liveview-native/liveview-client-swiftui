import SwiftUI
import SwiftSyntax

#if os(macOS)
extension WindowToolbarFullScreenVisibility: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "onHover": self = .onHover
        case "visible": self = .visible
        default: return nil
        }
    }
}
#endif
