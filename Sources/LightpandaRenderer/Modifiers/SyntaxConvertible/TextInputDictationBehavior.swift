import SwiftUI
import SwiftSyntax

#if os(iOS) || os(visionOS)
@available(iOS 17.0, visionOS 1.0, *)
extension TextInputDictationBehavior: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "inline": self = .inline(activation: .onLook)
        default: return nil
        }
    }
}
#endif
