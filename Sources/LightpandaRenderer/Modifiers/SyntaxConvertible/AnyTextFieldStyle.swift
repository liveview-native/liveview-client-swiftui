import SwiftUI
import SwiftSyntax

public struct AnyTextFieldStyle: TextFieldStyle, @preconcurrency SyntaxConvertible {
    let style: any TextFieldStyle
    
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "automatic":
                self.style = .automatic
            case "plain":
                self.style = .plain
            case "roundedBorder":
                self.style = .roundedBorder
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
    
    public func _body(configuration: SwiftUI.TextField<Self._Label>) -> some View {
        AnyView(configuration.textFieldStyle(style))
    }
}
