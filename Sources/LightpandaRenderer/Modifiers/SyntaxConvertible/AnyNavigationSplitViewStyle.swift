import SwiftUI
import SwiftSyntax

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct AnyNavigationSplitViewStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        case balanced
        case prominentDetail
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self.style = .automatic
        case "balanced":
            self.style = .balanced
        case "prominentDetail":
            self.style = .prominentDetail
        default:
            return nil
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@MainActor
private func _unboxNavigationSplitViewStyle(style: some NavigationSplitViewStyle, on view: some View) -> AnyView {
    AnyView(view.navigationSplitViewStyle(style))
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {
    @MainActor
    func navigationSplitViewStyle(_ style: AnyNavigationSplitViewStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxNavigationSplitViewStyle(style: .automatic, on: self)
        case .balanced:
            return _unboxNavigationSplitViewStyle(style: .balanced, on: self)
        case .prominentDetail:
            return _unboxNavigationSplitViewStyle(style: .prominentDetail, on: self)
        }
    }
}
#endif
