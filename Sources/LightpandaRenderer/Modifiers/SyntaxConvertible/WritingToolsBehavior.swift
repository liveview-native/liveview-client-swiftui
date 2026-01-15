import SwiftUI
import SwiftSyntax

#if os(iOS) || os(macOS) || os(visionOS)
@available(iOS 18.0, macOS 15.0, visionOS 2.4, *)
extension WritingToolsBehavior: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "complete": self = .complete
        case "limited": self = .limited
        case "disabled": self = .disabled
        default: return nil
        }
    }
}
#endif
