import SwiftUI
import SwiftSyntax

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
extension ButtonSizing: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "automatic":
                self = .automatic
            case "fitted":
                self = .fitted
            case "flexible":
                self = .flexible
            default:
                return nil
            }
            return
        }
        return nil
    }
}
