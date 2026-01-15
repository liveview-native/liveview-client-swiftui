import SwiftUI
import SwiftSyntax

extension ContentTransition: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "identity": self = .identity
        case "opacity": self = .opacity
        case "interpolate": self = .interpolate
        case "symbolEffect": self = .symbolEffect
        default: return nil
        }
    }
}
