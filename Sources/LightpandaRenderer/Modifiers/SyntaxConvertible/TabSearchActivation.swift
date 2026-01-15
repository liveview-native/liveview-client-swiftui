#if os(iOS) || os(macOS)
import SwiftUI
import SwiftSyntax

@available(iOS 26.0, macOS 26.0, *)
extension TabSearchActivation: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        default: return nil
        }
    }
}
#endif
