#if os(visionOS)
import SwiftUI
import SwiftSyntax

@available(visionOS 2.0, *)
extension VolumeViewpointUpdateStrategy: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "supported": self = .supported
        default: return nil
        }
    }
}
#endif
