import SwiftUI
import SwiftSyntax

public struct AnyTabViewStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        #if !os(macOS)
        case page
        #endif
        #if os(watchOS)
        case verticalPage
        case verticalPageWithTransition(VerticalPageTabViewStyle.TransitionStyle)
        #endif
        case sidebarAdaptable
        case tabBarOnly
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        // Handle function call syntax for verticalPage(transitionStyle:)
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "verticalPage" {
            #if os(watchOS)
            // Parse transitionStyle argument if present
            if let transitionStyleArg = functionCall.argument(named: "transitionStyle"),
               let transitionStyle = VerticalPageTabViewStyle.TransitionStyle(syntax: transitionStyleArg.expression) {
                self.style = .verticalPageWithTransition(transitionStyle)
                return
            }
            // Default to plain verticalPage if no transitionStyle argument
            self.style = .verticalPage
            return
            #else
            return nil
            #endif
        }

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
            #if os(watchOS)
            case "verticalPage":
                self.style = .verticalPage
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
        #if os(watchOS)
        case .verticalPage:
            return _unbox(style: .verticalPage, on: self)
        case .verticalPageWithTransition(let transitionStyle):
            return _unbox(style: .verticalPage(transitionStyle: transitionStyle), on: self)
        #endif
        case .sidebarAdaptable:
            return _unbox(style: .sidebarAdaptable, on: self)
        case .tabBarOnly:
            return _unbox(style: .tabBarOnly, on: self)
        }
    }
}
