import SwiftUI
import SwiftSyntax

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public struct AnyPresentationSizing: PresentationSizing, SyntaxConvertible, Sendable {
    enum Sizing: Sendable {
        case automatic
        case fitted
        case form
        case page
        case formFitted(horizontal: Bool, vertical: Bool)
        case pageFitted(horizontal: Bool, vertical: Bool)
        case formSticky(horizontal: Bool, vertical: Bool)
        case pageSticky(horizontal: Bool, vertical: Bool)
    }

    let sizing: Sizing

    public init?(syntax: some SyntaxProtocol) {
        // Handle simple member access (e.g., .automatic, .fitted, .form, .page)
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            if memberAccess.base == nil {
                switch memberAccess.declName.baseName.text {
                case "automatic":
                    self.sizing = .automatic
                case "fitted":
                    self.sizing = .fitted
                case "form":
                    self.sizing = .form
                case "page":
                    self.sizing = .page
                default:
                    return nil
                }
                return
            }
        }

        // Handle function calls (e.g., .form.fitted(horizontal: true, vertical: false))
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
            let methodName = memberAccess.declName.baseName.text

            // Parse the base (.form or .page)
            if let base = memberAccess.base?.as(MemberAccessExprSyntax.self),
               base.base == nil {
                let baseName = base.declName.baseName.text

                // Parse horizontal/vertical arguments with defaults
                let horizontal = functionCall.argument(named: "horizontal").flatMap { Bool(syntax: $0.expression) } ?? true
                let vertical = functionCall.argument(named: "vertical").flatMap { Bool(syntax: $0.expression) } ?? true

                switch (baseName, methodName) {
                case ("form", "fitted"):
                    self.sizing = .formFitted(horizontal: horizontal, vertical: vertical)
                    return
                case ("page", "fitted"):
                    self.sizing = .pageFitted(horizontal: horizontal, vertical: vertical)
                    return
                case ("form", "sticky"):
                    self.sizing = .formSticky(horizontal: horizontal, vertical: vertical)
                    return
                case ("page", "sticky"):
                    self.sizing = .pageSticky(horizontal: horizontal, vertical: vertical)
                    return
                default:
                    break
                }
            }
        }

        return nil
    }

    public func proposedSize(for root: PresentationSizingRoot, context: PresentationSizingContext) -> ProposedViewSize {
        switch sizing {
        case .automatic:
            return AutomaticPresentationSizing.automatic.proposedSize(for: root, context: context)
        case .fitted:
            return FittedPresentationSizing.fitted.proposedSize(for: root, context: context)
        case .form:
            return FormPresentationSizing.form.proposedSize(for: root, context: context)
        case .page:
            return PagePresentationSizing.page.proposedSize(for: root, context: context)
        case .formFitted(let horizontal, let vertical):
            return FormPresentationSizing.form.fitted(horizontal: horizontal, vertical: vertical).proposedSize(for: root, context: context)
        case .pageFitted(let horizontal, let vertical):
            return PagePresentationSizing.page.fitted(horizontal: horizontal, vertical: vertical).proposedSize(for: root, context: context)
        case .formSticky(let horizontal, let vertical):
            return FormPresentationSizing.form.sticky(horizontal: horizontal, vertical: vertical).proposedSize(for: root, context: context)
        case .pageSticky(let horizontal, let vertical):
            return PagePresentationSizing.page.sticky(horizontal: horizontal, vertical: vertical).proposedSize(for: root, context: context)
        }
    }
}
