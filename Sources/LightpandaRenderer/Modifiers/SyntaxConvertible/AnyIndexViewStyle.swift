import SwiftUI
import SwiftSyntax

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
public struct AnyIndexViewStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case page
        case pageAlwaysVisible
        case pageBackgroundNeverVisible
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "page":
            self.style = .page
        default:
            return nil
        }
    }

    public init?(syntax: some SyntaxProtocol, forceInit: Bool) {
        // Handle function calls like `.page(backgroundDisplayMode: .always)`
        if let funcCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = funcCall.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "page":
                // Check for backgroundDisplayMode argument
                if let backgroundMode = funcCall.argument(named: "backgroundDisplayMode"),
                   let modeAccess = backgroundMode.expression.as(MemberAccessExprSyntax.self) {
                    switch modeAccess.declName.baseName.text {
                    case "always":
                        self.style = .pageAlwaysVisible
                        return
                    case "never":
                        self.style = .pageBackgroundNeverVisible
                        return
                    default:
                        self.style = .page
                        return
                    }
                }
                self.style = .page
                return
            default:
                return nil
            }
        }
        return nil
    }
}

@MainActor
private func _unboxIndexViewStyle(style: some IndexViewStyle, on view: some View) -> AnyView {
    AnyView(view.indexViewStyle(style))
}

extension View {
    @MainActor
    func indexViewStyle(_ style: AnyIndexViewStyle) -> AnyView {
        switch style.style {
        case .page:
            return _unboxIndexViewStyle(style: PageIndexViewStyle(), on: self)
        case .pageAlwaysVisible:
            return _unboxIndexViewStyle(style: PageIndexViewStyle(backgroundDisplayMode: .always), on: self)
        case .pageBackgroundNeverVisible:
            return _unboxIndexViewStyle(style: PageIndexViewStyle(backgroundDisplayMode: .never), on: self)
        }
    }
}
#endif
