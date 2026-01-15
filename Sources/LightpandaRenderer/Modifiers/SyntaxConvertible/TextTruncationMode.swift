import SwiftUI
import SwiftSyntax

extension Text.TruncationMode: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "head": self = .head
        case "tail": self = .tail
        case "middle": self = .middle
        default: return nil
        }
    }
}
