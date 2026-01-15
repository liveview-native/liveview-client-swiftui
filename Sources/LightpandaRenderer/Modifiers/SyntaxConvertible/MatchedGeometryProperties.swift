import SwiftUI
import SwiftSyntax

extension MatchedGeometryProperties: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "frame": self = .frame
        case "position": self = .position
        case "size": self = .size
        default: return nil
        }
    }
}
