import SwiftUI
import SwiftSyntax

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension PresentationAdaptation: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "automatic": self = .automatic
        case "none": self = .none
        case "popover": self = .popover
        case "sheet": self = .sheet
        case "fullScreenCover": self = .fullScreenCover
        default: return nil
        }
    }
}
