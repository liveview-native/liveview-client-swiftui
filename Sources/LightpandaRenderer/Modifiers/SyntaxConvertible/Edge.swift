import SwiftUI
import SwiftSyntax

extension Edge.Set: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "top":
                self = .top
            case "leading":
                self = .leading
            case "bottom":
                self = .bottom
            case "trailing":
                self = .trailing
            case "horizontal":
                self = .horizontal
            case "vertical":
                self = .vertical
            case "all":
                self = .all
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
}
