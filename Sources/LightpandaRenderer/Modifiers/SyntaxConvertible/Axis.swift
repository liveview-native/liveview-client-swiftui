import SwiftUI
import SwiftSyntax

extension Axis: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }

        switch memberAccess.declName.baseName.text {
        case "horizontal":
            self = .horizontal
        case "vertical":
            self = .vertical
        default:
            return nil
        }
    }
}

extension Axis.Set: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }

        switch memberAccess.declName.baseName.text {
        case "horizontal":
            self = .horizontal
        case "vertical":
            self = .vertical
        default:
            return nil
        }
    }
}
