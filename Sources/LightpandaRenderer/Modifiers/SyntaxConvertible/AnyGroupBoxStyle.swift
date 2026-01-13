import SwiftUI
import SwiftSyntax

public struct AnyGroupBoxStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self.style = .automatic
        default:
            return nil
        }
    }
}

@MainActor
private func _unboxGroupBoxStyle(style: some GroupBoxStyle, on view: some View) -> AnyView {
    AnyView(view.groupBoxStyle(style))
}

extension View {
    @MainActor
    func groupBoxStyle(_ style: AnyGroupBoxStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxGroupBoxStyle(style: DefaultGroupBoxStyle(), on: self)
        }
    }
}
