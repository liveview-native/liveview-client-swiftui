import SwiftUI
import SwiftSyntax

public struct AnyFormStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        case columns
        case grouped
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self.style = .automatic
        case "columns":
            self.style = .columns
        case "grouped":
            self.style = .grouped
        default:
            return nil
        }
    }
}

@MainActor
private func _unboxFormStyle(style: some FormStyle, on view: some View) -> AnyView {
    AnyView(view.formStyle(style))
}

extension View {
    @MainActor
    func formStyle(_ style: AnyFormStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxFormStyle(style: AutomaticFormStyle(), on: self)
        case .columns:
            return _unboxFormStyle(style: ColumnsFormStyle(), on: self)
        case .grouped:
            return _unboxFormStyle(style: GroupedFormStyle(), on: self)
        }
    }
}
