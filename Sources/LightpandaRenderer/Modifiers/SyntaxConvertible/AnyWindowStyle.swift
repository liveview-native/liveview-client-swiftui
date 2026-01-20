import SwiftUI
import SwiftSyntax

/// Type-erased WindowStyle for runtime parsing.
/// Available on macOS 13+ and visionOS 1+.
#if os(macOS) || os(visionOS)
@available(macOS 13.0, visionOS 1.0, *)
public struct AnyWindowStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        #if os(macOS)
        case hiddenTitleBar
        case titleBar
        #endif
        #if os(visionOS)
        case plain
        case volumetric
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
            #if os(macOS)
            case "hiddenTitleBar":
                self.style = .hiddenTitleBar
            case "titleBar":
                self.style = .titleBar
            #endif
            #if os(visionOS)
            case "plain":
                self.style = .plain
            case "volumetric":
                self.style = .volumetric
            #endif
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}

@MainActor
@available(macOS 13.0, visionOS 1.0, *)
private func _unboxWindowStyle(style: some WindowStyle, on view: some View) -> AnyView {
    AnyView(view.presentedWindowStyle(style))
}

extension View {
    @MainActor
    @available(macOS 13.0, visionOS 1.0, *)
    func presentedWindowStyle(_ style: AnyWindowStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxWindowStyle(style: .automatic, on: self)
        #if os(macOS)
        case .hiddenTitleBar:
            return _unboxWindowStyle(style: .hiddenTitleBar, on: self)
        case .titleBar:
            return _unboxWindowStyle(style: .titleBar, on: self)
        #endif
        #if os(visionOS)
        case .plain:
            return _unboxWindowStyle(style: .plain, on: self)
        case .volumetric:
            return _unboxWindowStyle(style: .volumetric, on: self)
        #endif
        }
    }
}
#endif
