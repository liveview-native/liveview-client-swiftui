import SwiftUI
import SwiftSyntax

/// Type-erased NavigationViewStyle for runtime parsing.
/// Note: NavigationView is deprecated in favor of NavigationStack/NavigationSplitView,
/// but this style is still useful for legacy code compatibility.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use NavigationStack or NavigationSplitView instead")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "use NavigationStack or NavigationSplitView instead")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use NavigationStack or NavigationSplitView instead")
@available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "use NavigationStack or NavigationSplitView instead")
@available(visionOS, introduced: 1.0, deprecated: 100000.0, message: "use NavigationStack or NavigationSplitView instead")
public struct AnyNavigationViewStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        #if !os(macOS)
        case stack
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case columns
        #endif
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }

        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "automatic":
                self.style = .automatic
            #if !os(macOS)
            case "stack":
                self.style = .stack
            #endif
            #if os(iOS) || os(macOS) || os(visionOS)
            case "columns":
                self.style = .columns
            #endif
            default:
                return nil
            }
        } else {
            // FIXME: Handle base name (e.g., StackNavigationViewStyle())
            return nil
        }
    }
}

@MainActor
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, visionOS 1.0, *)
private func _unboxNavigationViewStyle(style: some NavigationViewStyle, on view: some View) -> AnyView {
    AnyView(view.navigationViewStyle(style))
}

extension View {
    @MainActor
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, visionOS 1.0, *)
    func navigationViewStyle(_ style: AnyNavigationViewStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxNavigationViewStyle(style: DefaultNavigationViewStyle(), on: self)
        #if !os(macOS)
        case .stack:
            return _unboxNavigationViewStyle(style: StackNavigationViewStyle(), on: self)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case .columns:
            return _unboxNavigationViewStyle(style: DoubleColumnNavigationViewStyle(), on: self)
        #endif
        }
    }
}
