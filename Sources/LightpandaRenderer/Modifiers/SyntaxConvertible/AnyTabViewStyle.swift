import SwiftUI
import SwiftSyntax

public struct AnyTabViewStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        #if !os(macOS)
        case page
        #endif
        case sidebarAdaptable
        case tabBarOnly
    }
    
    let style: Style
    
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }
        
        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "automatic":
                self.style = .automatic
            #if !os(macOS)
            case "page":
                self.style = .page
            #endif
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

@MainActor
func _unbox(style: some TabViewStyle, on view: some View) -> AnyView {
    AnyView(view.tabViewStyle(style))
}

extension View {
    @MainActor
    func tabViewStyle(_ style: AnyTabViewStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unbox(style: .automatic, on: self)
        #if !os(macOS)
        case .page:
            return _unbox(style: .page, on: self)
        #endif
        case .sidebarAdaptable:
            return _unbox(style: .sidebarAdaptable, on: self)
        case .tabBarOnly:
            return _unbox(style: .tabBarOnly, on: self)
        }
    }
}
