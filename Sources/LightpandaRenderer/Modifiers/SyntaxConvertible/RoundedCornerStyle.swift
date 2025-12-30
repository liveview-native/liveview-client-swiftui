import SwiftUI
import SwiftSyntax

extension RoundedCornerStyle: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil
        else { return nil }
        
        switch memberAccess.declName.baseName.text {
        case "circular":
            self = .circular
        case "continuous":
            self = .continuous
        default:
            return nil
        }
    }
}
