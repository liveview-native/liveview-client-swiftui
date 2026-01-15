import SwiftUI
import SwiftSyntax

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
extension PageTabViewStyle.IndexDisplayMode: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "always": self = .always
        case "never": self = .never
        default: return nil
        }
    }
}

extension PageIndexViewStyle.BackgroundDisplayMode: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "interactive": self = .interactive
        case "always": self = .always
        case "never": self = .never
        default: return nil
        }
    }
}
#endif
