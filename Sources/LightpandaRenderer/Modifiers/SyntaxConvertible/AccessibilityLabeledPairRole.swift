import SwiftUI
import SwiftSyntax

extension SwiftUI.AccessibilityLabeledPairRole: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Try parsing as a member access (e.g., .label, .content)
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            switch memberAccess.declName.baseName.text {
            case "label":
                self = .label
            case "content":
                self = .content
            default:
                return nil
            }
            return
        }

        // Try parsing as a string literal (e.g., "label", "content")
        if let string = String(syntax: syntax) {
            switch string {
            case "label":
                self = .label
            case "content":
                self = .content
            default:
                return nil
            }
            return
        }

        return nil
    }
}
