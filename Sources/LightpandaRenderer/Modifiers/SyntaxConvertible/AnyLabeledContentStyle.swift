import SwiftUI
import SwiftSyntax

public struct AnyLabeledContentStyle: SyntaxConvertible, Sendable {
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
private func _unboxLabeledContentStyle(style: some LabeledContentStyle, on view: some View) -> AnyView {
    AnyView(view.labeledContentStyle(style))
}

extension View {
    @MainActor
    func labeledContentStyle(_ style: AnyLabeledContentStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxLabeledContentStyle(style: AutomaticLabeledContentStyle(), on: self)
        }
    }
}
