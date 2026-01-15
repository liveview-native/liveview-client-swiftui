import SwiftUI
import SwiftSyntax

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ContainerBackgroundPlacement: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        #if os(watchOS)
        case "navigation": self = .navigation
        case "tabView": self = .tabView
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS)
        case "navigation": self = .navigation
        #endif
        default: return nil
        }
    }
}
