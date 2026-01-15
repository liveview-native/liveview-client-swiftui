import SwiftUI
import SwiftSyntax

extension DynamicTypeSize: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "xSmall": self = .xSmall
        case "small": self = .small
        case "medium": self = .medium
        case "large": self = .large
        case "xLarge": self = .xLarge
        case "xxLarge": self = .xxLarge
        case "xxxLarge": self = .xxxLarge
        case "accessibility1": self = .accessibility1
        case "accessibility2": self = .accessibility2
        case "accessibility3": self = .accessibility3
        case "accessibility4": self = .accessibility4
        case "accessibility5": self = .accessibility5
        default: return nil
        }
    }
}
