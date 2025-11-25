import SwiftUI
import SwiftSyntax

extension TextAlignment: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "leading":
                self = .leading
            case "center":
                self = .center
            case "trailing":
                self = .trailing
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
}
