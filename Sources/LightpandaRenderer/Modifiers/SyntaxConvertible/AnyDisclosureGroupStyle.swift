import SwiftUI
import SwiftSyntax

public struct AnyDisclosureGroupStyle: SyntaxConvertible, Sendable {
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
private func _unboxDisclosureGroupStyle(style: some DisclosureGroupStyle, on view: some View) -> AnyView {
    AnyView(view.disclosureGroupStyle(style))
}

extension View {
    @MainActor
    func disclosureGroupStyle(_ style: AnyDisclosureGroupStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxDisclosureGroupStyle(style: AutomaticDisclosureGroupStyle(), on: self)
        }
    }
}
