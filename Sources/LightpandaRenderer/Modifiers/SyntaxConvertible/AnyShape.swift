import SwiftUI
import SwiftSyntax

extension AnyShape: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "buttonBorder":
                self = AnyShape(.buttonBorder)
            case "capsule":
                self = AnyShape(.capsule)
            case "circle":
                self = AnyShape(.circle)
            case "containerRelative":
                self = AnyShape(.containerRelative)
            case "ellipse":
                self = AnyShape(.ellipse)
            case "rect":
                self = AnyShape(.rect)
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
}
