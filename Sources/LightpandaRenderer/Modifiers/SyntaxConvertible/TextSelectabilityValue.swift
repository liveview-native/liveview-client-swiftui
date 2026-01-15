import SwiftUI
import SwiftSyntax

/// Simple enum for text selectability that can be parsed from syntax
public enum TextSelectabilityValue: SyntaxConvertible, Sendable {
    case enabled
    case disabled

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "enabled": self = .enabled
        case "disabled": self = .disabled
        default: return nil
        }
    }
}
