import SwiftUI
import SwiftSyntax

#if os(iOS) || os(tvOS) || os(visionOS)
@available(iOS 13.4, tvOS 16.0, *)
extension HoverEffect: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "highlight": self = .highlight
        case "lift": self = .lift
        default: return nil
        }
    }
}
#endif
