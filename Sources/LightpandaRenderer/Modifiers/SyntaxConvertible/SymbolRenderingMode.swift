import SwiftUI
import SwiftSyntax

extension SymbolRenderingMode: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "monochrome": self = .monochrome
        case "multicolor": self = .multicolor
        case "hierarchical": self = .hierarchical
        case "palette": self = .palette
        default: return nil
        }
    }
}
