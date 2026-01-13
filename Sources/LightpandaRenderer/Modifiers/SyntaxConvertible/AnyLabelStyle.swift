import SwiftUI
import SwiftSyntax

public struct AnyLabelStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        case iconOnly
        case titleAndIcon
        case titleOnly
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self.style = .automatic
        case "iconOnly":
            self.style = .iconOnly
        case "titleAndIcon":
            self.style = .titleAndIcon
        case "titleOnly":
            self.style = .titleOnly
        default:
            return nil
        }
    }
}

@MainActor
private func _unboxLabelStyle(style: some LabelStyle, on view: some View) -> AnyView {
    AnyView(view.labelStyle(style))
}

extension View {
    @MainActor
    func labelStyle(_ style: AnyLabelStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxLabelStyle(style: DefaultLabelStyle(), on: self)
        case .iconOnly:
            return _unboxLabelStyle(style: IconOnlyLabelStyle(), on: self)
        case .titleAndIcon:
            return _unboxLabelStyle(style: TitleAndIconLabelStyle(), on: self)
        case .titleOnly:
            return _unboxLabelStyle(style: TitleOnlyLabelStyle(), on: self)
        }
    }
}
