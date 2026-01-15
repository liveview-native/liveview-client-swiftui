import SwiftUI
import SwiftSyntax

extension Image.Scale: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "small": self = .small
        case "medium": self = .medium
        case "large": self = .large
        default: return nil
        }
    }
}
