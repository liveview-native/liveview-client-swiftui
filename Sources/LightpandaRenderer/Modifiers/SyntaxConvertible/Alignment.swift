import SwiftUI
import SwiftSyntax

extension Alignment: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "bottom":
                self = .bottom
            case "bottomLeading":
                self = .bottomLeading
            case "bottomTrailing":
                self = .bottomTrailing
            case "center":
                self = .center
            case "centerFirstTextBaseline":
                self = .centerFirstTextBaseline
            case "centerLastTextBaseline":
                self = .centerLastTextBaseline
            case "leading":
                self = .leading
            case "leadingFirstTextBaseline":
                self = .leadingFirstTextBaseline
            case "leadingLastTextBaseline":
                self = .leadingLastTextBaseline
            case "top":
                self = .top
            case "topLeading":
                self = .topLeading
            case "topTrailing":
                self = .topTrailing
            case "trailing":
                self = .trailing
            case "trailingFirstTextBaseline":
                self = .trailingFirstTextBaseline
            case "trailingLastTextBaseline":
                self = .trailingLastTextBaseline
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
}
