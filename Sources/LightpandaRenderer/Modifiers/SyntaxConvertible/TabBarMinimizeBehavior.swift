import SwiftUI
import SwiftSyntax

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
extension TabBarMinimizeBehavior: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        #if os(iOS)
        case "onScrollDown": self = .onScrollDown
        case "onScrollUp": self = .onScrollUp
        case "never": self = .never
        #endif
        default: return nil
        }
    }
}
