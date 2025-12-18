import SwiftUI
import SwiftSyntax

public struct AnyTabViewStyle: @preconcurrency SyntaxConvertible {
    let style: any TabViewStyle
    
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "automatic":
                self.style = .automatic
            case "page":
                self.style = .page
            case "sidebarAdaptable":
                self.style = .sidebarAdaptable
            case "tabBarOnly":
                self.style = .tabBarOnly
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name
            return nil
        }
    }
    
}

func _unbox(style: some TabViewStyle, on view: some View) -> AnyView {
    AnyView(view.tabViewStyle(style))
}

extension View {
    func tabViewStyle(_ style: AnyTabViewStyle) -> AnyView {
        _unbox(style: style.style, on: self)
    }
}
