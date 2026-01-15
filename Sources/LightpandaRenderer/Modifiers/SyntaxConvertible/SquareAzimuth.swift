#if os(visionOS)
import SwiftUI
import SwiftSyntax

@available(visionOS 2.0, *)
extension SquareAzimuth.Set: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "all": self = .all
        case "front": self = .front
        case "back": self = .back
        case "left": self = .left
        case "right": self = .right
        default: return nil
        }
    }
}
#endif
