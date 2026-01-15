import SwiftUI
import SwiftSyntax

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension NamedCoordinateSpace: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "scrollView": self = .scrollView
        default: return nil
        }
    }
}
