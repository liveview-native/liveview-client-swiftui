import SwiftUI
import SwiftSyntax

extension SymbolVariants: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "none": self = .none
        case "circle": self = .circle
        case "square": self = .square
        case "rectangle": self = .rectangle
        case "fill": self = .fill
        case "slash": self = .slash
        default: return nil
        }
    }
}
