import SwiftUI
import SwiftSyntax

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, *)
extension AdaptableTabBarPlacement: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "sidebar": self = .sidebar
        case "tabBar": self = .tabBar
        default: return nil
        }
    }
}
