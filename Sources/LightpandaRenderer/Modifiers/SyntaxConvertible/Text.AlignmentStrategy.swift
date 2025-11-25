import SwiftUI
import SwiftSyntax

extension Text.AlignmentStrategy: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "default":
                self = .default
            case "layoutBased":
                self = .layoutBased
            case "writingDirectionBased":
                self = .writingDirectionBased
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
}
