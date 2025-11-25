import SwiftUI
import SwiftSyntax

public struct AnyPrimitiveButtonStyle: PrimitiveButtonStyle, @preconcurrency SyntaxConvertible {
    let style: any PrimitiveButtonStyle
    
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "automatic":
                self.style = .automatic
            case "bordered":
                self.style = .bordered
            case "borderedProminent":
                self.style = .borderedProminent
            case "borderless":
                self.style = .borderless
            case "glass":
                self.style = .glass
            case "glassProminent":
                self.style = .glassProminent
            case "plain":
                self.style = .plain
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        AnyView(style.makeBody(configuration: configuration))
    }
}
