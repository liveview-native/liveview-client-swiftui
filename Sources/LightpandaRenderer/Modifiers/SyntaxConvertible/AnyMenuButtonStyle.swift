#if os(macOS)
import SwiftUI
import SwiftSyntax

/// A type-erased wrapper for MenuButtonStyle values that can be parsed from syntax.
/// Note: MenuButtonStyle is deprecated in macOS 12.3+ but still available for compatibility.
@available(macOS, deprecated: 12.3, message: "Use Menu with menuStyle instead")
public enum AnyMenuButtonStyle: SyntaxConvertible {
    case automatic
    case borderlessButton

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic", "default":
            self = .automatic
        case "borderlessButton":
            self = .borderlessButton
        default:
            return nil
        }
    }
}
#endif
