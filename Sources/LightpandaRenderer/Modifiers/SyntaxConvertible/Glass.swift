import SwiftUI
import SwiftSyntax

extension Glass: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "automatic":
                self = .clear
            case "bordered":
                self = .identity
            case "borderedProminent":
                self = .regular
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
}
