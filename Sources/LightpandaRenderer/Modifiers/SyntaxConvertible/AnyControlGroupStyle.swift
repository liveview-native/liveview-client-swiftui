import SwiftUI
import SwiftSyntax

public struct AnyControlGroupStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        case menu
        case navigation
        #if os(iOS) || os(macOS)
        case palette
        #endif
        #if os(macOS)
        case compactMenu
        #endif
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self.style = .automatic
        case "menu":
            self.style = .menu
        case "navigation":
            self.style = .navigation
        #if os(iOS) || os(macOS)
        case "palette":
            self.style = .palette
        #endif
        #if os(macOS)
        case "compactMenu":
            self.style = .compactMenu
        #endif
        default:
            return nil
        }
    }
}

@MainActor
private func _unboxControlGroupStyle(style: some ControlGroupStyle, on view: some View) -> AnyView {
    AnyView(view.controlGroupStyle(style))
}

extension View {
    @MainActor
    func controlGroupStyle(_ style: AnyControlGroupStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxControlGroupStyle(style: .automatic, on: self)
        case .menu:
            return _unboxControlGroupStyle(style: .menu, on: self)
        case .navigation:
            return _unboxControlGroupStyle(style: .navigation, on: self)
        #if os(iOS) || os(macOS)
        case .palette:
            return _unboxControlGroupStyle(style: .palette, on: self)
        #endif
        #if os(macOS)
        case .compactMenu:
            return _unboxControlGroupStyle(style: .compactMenu, on: self)
        #endif
        }
    }
}
