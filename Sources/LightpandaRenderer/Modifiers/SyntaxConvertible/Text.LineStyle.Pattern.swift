import SwiftUI
import SwiftSyntax

extension Text.LineStyle.Pattern: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "dash":
                self = .dash
            case "dashDot":
                self = .dashDot
            case "dashDotDot":
                self = .dashDotDot
            case "dot":
                self = .dot
            case "solid":
                self = .solid
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
}
