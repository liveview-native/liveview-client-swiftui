import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for creating a focus scope.
/// Focus scopes group focusable views and enable default focus behavior.
///
/// Usage:
/// ```html
/// <!-- Create a focus scope with an identifier -->
/// <vstack modifiers="focusScope(loginForm)">
///     <textfield modifiers="prefersDefaultFocus(in: loginForm)">
///     <textfield>
/// </vstack>
/// ```
///
/// Note: The scope identifier is used to coordinate focus within the scope.
/// Use the same identifier in `prefersDefaultFocus(in:)` to reference this scope.
///
/// Note: focusScope is only available on macOS, tvOS, and watchOS - not iOS.
#if os(macOS) || os(tvOS) || os(watchOS)
public enum FocusScopeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case focusScope(String)
}

extension FocusScopeModifier: RuntimeViewModifier {
    public static var baseName: String { "focusScope" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse identifier like focusScope(loginForm)
        if let scopeId = syntax.arguments.first
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) {
            self = .focusScope(scopeId)
            return
        }

        // Also support string literal focusScope("loginForm")
        if let scopeId = syntax.arguments.first
            .flatMap({ String(syntax: $0.expression) }) {
            self = .focusScope(scopeId)
            return
        }

        throw ModifierParseError.missingRequiredArgument(modifier: "FocusScopeModifier", argument: "namespace")
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        FocusScopeBody(scopeId: scopeId, content: _content)
    }

    private var scopeId: String {
        switch self {
        case .focusScope(let id): return id
        }
    }
}

private struct FocusScopeBody<Content: View>: View {
    let scopeId: String
    let content: Content

    @Namespace private var namespace
    @Environment(\.focusNamespaces) private var focusNamespaces

    var body: some View {
        content
            .focusScope(namespace)
            .environment(\.focusNamespaces, focusNamespaces.adding(scopeId, namespace: namespace))
    }
}

// MARK: - Focus Namespace Registry

/// Environment key for storing focus namespace mappings.
private struct FocusNamespacesKey: EnvironmentKey {
    static let defaultValue = FocusNamespaceRegistry()
}

extension EnvironmentValues {
    var focusNamespaces: FocusNamespaceRegistry {
        get { self[FocusNamespacesKey.self] }
        set { self[FocusNamespacesKey.self] = newValue }
    }
}

/// Registry mapping string identifiers to Namespace.ID values.
struct FocusNamespaceRegistry: Sendable {
    private var namespaces: [String: Namespace.ID] = [:]

    func adding(_ id: String, namespace: Namespace.ID) -> FocusNamespaceRegistry {
        var copy = self
        copy.namespaces[id] = namespace
        return copy
    }

    func namespace(for id: String) -> Namespace.ID? {
        namespaces[id]
    }
}
#endif
