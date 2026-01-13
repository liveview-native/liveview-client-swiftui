import SwiftUI
import SwiftSyntax

public struct AnyMenuStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        case button
        #if os(macOS)
        case borderlessButton
        #endif
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self.style = .automatic
        case "button":
            self.style = .button
        #if os(macOS)
        case "borderlessButton":
            self.style = .borderlessButton
        #endif
        default:
            return nil
        }
    }
}

@MainActor
private func _unboxMenuStyle(style: some MenuStyle, on view: some View) -> AnyView {
    AnyView(view.menuStyle(style))
}

extension View {
    @MainActor
    func menuStyle(_ style: AnyMenuStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxMenuStyle(style: DefaultMenuStyle(), on: self)
        case .button:
            return _unboxMenuStyle(style: ButtonMenuStyle(), on: self)
        #if os(macOS)
        case .borderlessButton:
            return _unboxMenuStyle(style: BorderlessButtonMenuStyle(), on: self)
        #endif
        }
    }
}
