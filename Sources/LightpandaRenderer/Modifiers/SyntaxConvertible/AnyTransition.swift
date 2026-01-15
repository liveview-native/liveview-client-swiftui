import SwiftUI
import SwiftSyntax

extension AnyTransition: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "identity": self = .identity
        case "opacity": self = .opacity
        case "slide": self = .slide
        case "scale": self = .scale
        default: return nil
        }
    }
}
