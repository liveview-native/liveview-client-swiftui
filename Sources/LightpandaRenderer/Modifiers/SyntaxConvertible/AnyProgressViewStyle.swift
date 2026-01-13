import SwiftUI
import SwiftSyntax

public struct AnyProgressViewStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        case circular
        case linear
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self.style = .automatic
        case "circular":
            self.style = .circular
        case "linear":
            self.style = .linear
        default:
            return nil
        }
    }
}

@MainActor
private func _unboxProgressViewStyle(style: some ProgressViewStyle, on view: some View) -> AnyView {
    AnyView(view.progressViewStyle(style))
}

extension View {
    @MainActor
    func progressViewStyle(_ style: AnyProgressViewStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxProgressViewStyle(style: DefaultProgressViewStyle(), on: self)
        case .circular:
            return _unboxProgressViewStyle(style: CircularProgressViewStyle(), on: self)
        case .linear:
            return _unboxProgressViewStyle(style: LinearProgressViewStyle(), on: self)
        }
    }
}
