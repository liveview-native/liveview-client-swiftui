import SwiftUI
import SwiftSyntax

extension ColorRenderingMode: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "nonLinear": self = .nonLinear
        case "linear": self = .linear
        case "extendedLinear": self = .extendedLinear
        default: return nil
        }
    }
}
