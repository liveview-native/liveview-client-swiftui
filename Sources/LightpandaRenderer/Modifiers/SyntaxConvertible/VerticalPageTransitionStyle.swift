import SwiftUI
import SwiftSyntax

#if os(watchOS)
extension VerticalPageTabViewStyle.TransitionStyle: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "identity":
            self = .identity
        case "automatic":
            self = .automatic
        default:
            return nil
        }
    }
}
#endif
