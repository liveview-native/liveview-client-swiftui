import SwiftUI
import SwiftSyntax

#if os(macOS)
@available(macOS 26.0, *)
extension DragDropPreviewsFormation: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "default": self = .default
        case "none": self = .none
        case "pile": self = .pile
        case "list": self = .list
        case "stack": self = .stack
        default: return nil
        }
    }
}
#endif
