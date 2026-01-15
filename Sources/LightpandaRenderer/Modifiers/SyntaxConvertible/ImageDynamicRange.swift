import SwiftUI
import SwiftSyntax

extension Image.DynamicRange: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "standard": self = .standard
        case "constrainedHigh": self = .constrainedHigh
        case "high": self = .high
        default: return nil
        }
    }
}
