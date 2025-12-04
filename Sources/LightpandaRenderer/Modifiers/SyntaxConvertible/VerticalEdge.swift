import SwiftUI
import SwiftSyntax

extension VerticalEdge: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "bottom":
                self = .bottom
            case "top":
                self = .top
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
}
