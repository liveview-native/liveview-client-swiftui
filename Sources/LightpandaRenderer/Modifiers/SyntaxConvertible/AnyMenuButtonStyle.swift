#if os(macOS)
import SwiftUI
import SwiftSyntax

/// A type-erased wrapper for MenuButtonStyle that can be parsed from syntax.
/// Note: MenuButtonStyle is deprecated in macOS 12.3+ but still available for compatibility.
@available(macOS, deprecated: 12.3, message: "Use Menu with menuStyle instead")
public struct AnyMenuButtonStyle: MenuButtonStyle, @preconcurrency SyntaxConvertible {
    enum Style {
        case `default`
        case borderlessButton
        case borderlessPullDown
        case pullDown
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic", "default":
            self.style = .default
        case "borderlessButton":
            self.style = .borderlessButton
        case "borderlessPullDown":
            self.style = .borderlessPullDown
        case "pullDown":
            self.style = .pullDown
        default:
            return nil
        }
    }

    public func makeBody(configuration: Configuration) -> some View {
        switch style {
        case .default:
            DefaultMenuButtonStyle().makeBody(configuration: configuration)
        case .borderlessButton:
            BorderlessButtonMenuButtonStyle().makeBody(configuration: configuration)
        case .borderlessPullDown:
            BorderlessPullDownMenuButtonStyle().makeBody(configuration: configuration)
        case .pullDown:
            PullDownMenuButtonStyle().makeBody(configuration: configuration)
        }
    }
}
#endif
