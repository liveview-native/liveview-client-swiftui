import SwiftUI
import SwiftSyntax

extension VerticalAlignment: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "top":
                self = .top
            case "center":
                self = .center
            case "bottom":
                self = .bottom
            case "firstTextBaseline":
                self = .firstTextBaseline
            case "lastTextBaseline":
                self = .lastTextBaseline
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
}
