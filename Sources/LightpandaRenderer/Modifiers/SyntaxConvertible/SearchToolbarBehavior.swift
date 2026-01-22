import SwiftUI
import SwiftSyntax

#if os(iOS) || os(visionOS)
@available(iOS 26.0, visionOS 26.0, *)
extension SearchToolbarBehavior: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "minimize": self = .minimize
        default: return nil
        }
    }
}
#elseif os(macOS) || os(tvOS) || os(watchOS)
@available(macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension SearchToolbarBehavior: SyntaxConvertible {
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
