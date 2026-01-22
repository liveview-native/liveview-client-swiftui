import SwiftUI
import SwiftSyntax

extension SwiftUI.Image.TemplateRenderingMode: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        switch memberAccess.declName.baseName.text {
        case "template":
            self = .template
        case "original":
            self = .original
        default:
            return nil
        }
    }
}

extension SwiftUI.Image.Interpolation: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        switch memberAccess.declName.baseName.text {
        case "none":
            self = .none
        case "low":
            self = .low
        case "medium":
            self = .medium
        case "high":
            self = .high
        default:
            return nil
        }
    }
}
