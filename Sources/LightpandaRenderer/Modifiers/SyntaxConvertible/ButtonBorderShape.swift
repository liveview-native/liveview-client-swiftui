import SwiftUI
import SwiftSyntax

extension ButtonBorderShape: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "capsule": self = .capsule
        case "roundedRectangle": self = .roundedRectangle
        case "circle": if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            self = .circle
        } else {
            return nil
        }
        default: return nil
        }
    }
}
