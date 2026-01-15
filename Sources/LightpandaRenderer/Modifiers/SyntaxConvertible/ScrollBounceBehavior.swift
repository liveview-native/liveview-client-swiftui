import SwiftUI
import SwiftSyntax

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension ScrollBounceBehavior: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "always": self = .always
        case "basedOnSize": self = .basedOnSize
        default: return nil
        }
    }
}
