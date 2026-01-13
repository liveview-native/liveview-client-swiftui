import SwiftUI
import SwiftSyntax

public struct AnyToggleStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        case button
        case `switch`
        #if os(macOS)
        case checkbox
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
        case "switch":
            self.style = .switch
        #if os(macOS)
        case "checkbox":
            self.style = .checkbox
        #endif
        default:
            return nil
        }
    }
}

@MainActor
private func _unboxToggleStyle(style: some ToggleStyle, on view: some View) -> AnyView {
    AnyView(view.toggleStyle(style))
}

extension View {
    @MainActor
    func toggleStyle(_ style: AnyToggleStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxToggleStyle(style: DefaultToggleStyle(), on: self)
        case .button:
            return _unboxToggleStyle(style: ButtonToggleStyle(), on: self)
        case .switch:
            return _unboxToggleStyle(style: SwitchToggleStyle(), on: self)
        #if os(macOS)
        case .checkbox:
            return _unboxToggleStyle(style: CheckboxToggleStyle(), on: self)
        #endif
        }
    }
}
