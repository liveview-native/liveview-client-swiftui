import SwiftUI
import SwiftSyntax

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ContentMarginPlacement: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "scrollContent": self = .scrollContent
        case "scrollIndicators": self = .scrollIndicators
        default: return nil
        }
    }
}
