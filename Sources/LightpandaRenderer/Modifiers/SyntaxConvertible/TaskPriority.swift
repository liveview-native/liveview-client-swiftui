import SwiftSyntax

extension TaskPriority: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "high": self = .high
        case "medium": self = .medium
        case "low": self = .low
        case "background": self = .background
        case "userInitiated": self = .userInitiated
        case "utility": self = .utility
        default: return nil
        }
    }
}
