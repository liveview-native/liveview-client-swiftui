import SwiftUI
import SwiftSyntax

#if os(macOS)
/// Type-erased wrapper for WindowToolbarStyle that can be parsed from syntax.
public struct AnyWindowToolbarStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        case expanded
        case unified
        case unifiedCompact
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self.style = .automatic
        case "expanded":
            self.style = .expanded
        case "unified":
            self.style = .unified
        case "unifiedCompact":
            self.style = .unifiedCompact
        default:
            return nil
        }
    }
}

@MainActor
private func _unboxWindowToolbarStyle(style: some WindowToolbarStyle, on view: some View) -> AnyView {
    AnyView(view.presentedWindowToolbarStyle(style))
}

extension View {
    @MainActor
    func presentedWindowToolbarStyle(_ style: AnyWindowToolbarStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxWindowToolbarStyle(style: .automatic, on: self)
        case .expanded:
            return _unboxWindowToolbarStyle(style: .expanded, on: self)
        case .unified:
            return _unboxWindowToolbarStyle(style: .unified, on: self)
        case .unifiedCompact:
            return _unboxWindowToolbarStyle(style: .unifiedCompact, on: self)
        }
    }
}
#endif
