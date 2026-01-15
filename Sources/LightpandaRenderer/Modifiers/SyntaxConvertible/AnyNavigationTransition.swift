import SwiftUI
import SwiftSyntax

/// A type-erased wrapper for NavigationTransition values.
/// This struct exists without availability constraints so it can be stored in Any
/// and cast back at runtime. The actual View extension that applies the transition
/// has the appropriate availability constraints.
public struct AnyNavigationTransition: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }

        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "automatic":
                self.style = .automatic
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
@MainActor
private func _unbox(transition: some NavigationTransition, on view: some View) -> AnyView {
    AnyView(view.navigationTransition(transition))
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension View {
    @MainActor
    func navigationTransition(_ transition: AnyNavigationTransition) -> AnyView {
        switch transition.style {
        case .automatic:
            return _unbox(transition: .automatic, on: self)
        }
    }
}
