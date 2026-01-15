import SwiftUI
import SwiftSyntax

extension PaletteSelectionEffect: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "symbolVariant": self = .symbolVariant(.none)
        case "custom": return nil // Can't parse closure
        default: return nil
        }
    }
}
