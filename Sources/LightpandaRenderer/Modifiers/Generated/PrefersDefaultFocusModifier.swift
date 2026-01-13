import SwiftUI
import SwiftSyntax

/// Modifier for indicating a view should receive default focus within a scope.
///
/// Usage:
/// ```html
/// <!-- Mark a view as preferring default focus within a scope -->
/// <vstack modifiers="focusScope(loginForm)">
///     <textfield modifiers="prefersDefaultFocus(in: loginForm)">
///     <textfield>
/// </vstack>
///
/// <!-- Conditionally prefer default focus -->
/// <textfield modifiers="prefersDefaultFocus(false, in: loginForm)">
/// ```
///
/// Note: The scope identifier must match a parent `focusScope()` modifier.
/// Note: prefersDefaultFocus is only available on macOS, tvOS, and watchOS - not iOS.
#if os(macOS) || os(tvOS) || os(watchOS)
public enum PrefersDefaultFocusModifier<Library: ElementLibrary>: @unchecked Sendable {
    case prefersDefaultFocus(Bool, in: String)
}

extension PrefersDefaultFocusModifier: RuntimeViewModifier {
    public static var baseName: String { "prefersDefaultFocus" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let prefersDefault = syntax.arguments.first
            .flatMap({ Bool(syntax: $0.expression) }) ?? true

        // Parse the scope identifier from the "in:" parameter
        if let inArg = syntax.argument(named: "in") {
            // Try identifier: prefersDefaultFocus(in: loginForm)
            if let scopeId = inArg.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
                self = .prefersDefaultFocus(prefersDefault, in: scopeId)
                return
            }
            // Try string: prefersDefaultFocus(in: "loginForm")
            if let scopeId = String(syntax: inArg.expression) {
                self = .prefersDefaultFocus(prefersDefault, in: scopeId)
                return
            }
        }

        throw ModifierParseError.missingRequiredArgument(modifier: "PrefersDefaultFocusModifier", argument: "in")
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .prefersDefaultFocus(let prefers, let scopeId):
            PrefersDefaultFocusBody(prefers: prefers, scopeId: scopeId, content: _content)
        }
    }
}

private struct PrefersDefaultFocusBody<Content: View>: View {
    let prefers: Bool
    let scopeId: String
    let content: Content

    @Environment(\.focusNamespaces) private var focusNamespaces

    var body: some View {
        if let namespace = focusNamespaces.namespace(for: scopeId) {
            content.prefersDefaultFocus(prefers, in: namespace)
        } else {
            // Scope not found, just return content
            content
        }
    }
}
#endif
