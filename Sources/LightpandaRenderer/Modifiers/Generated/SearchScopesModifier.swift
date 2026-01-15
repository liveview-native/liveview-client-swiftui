import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for adding search scope filtering to searchable views.
///
/// Supported variants:
/// - `.searchScopes($activeScope, scopes: scopesTemplate)` - basic search scopes
/// - `.searchScopes($activeScope, activation: .onTextEntry, scopes: scopesTemplate)` - with activation strategy
///
/// ## Usage
/// ```html
/// <navigationstack modifiers='searchable(text: $searchText).searchScopes($scope, scopes: searchScopes)'>
///     <text template="searchScopes" tag="all">All</text>
///     <text template="searchScopes" tag="favorites">Favorites</text>
///     <text template="searchScopes" tag="recent">Recent</text>
///
///     <list>...</list>
/// </navigationstack>
/// ```
///
/// ## Event Handling
/// The `$scope` binding dispatches a `scopeChanged` event when the selection changes:
/// ```javascript
/// element.addEventListener("scopeChanged", (event) => {
///     console.log("Selected scope:", event.detail.value);
/// });
///
/// // Set initial scope
/// element.setAttribute("scope", "favorites");
/// ```
#if os(iOS) || os(macOS) || os(tvOS)
@MainActor
public enum SearchScopesModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// searchScopes($selection, scopes: { ... })
    case searchScopes(selection: NodeBinding<String>, scopes: ViewReference<Library>)

    /// searchScopes($selection, activation: .onTextEntry, scopes: { ... })
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, *)
    case searchScopesWithActivation(selection: NodeBinding<String>, activation: SearchScopeActivation, scopes: ViewReference<Library>)
}

extension SearchScopesModifier: RuntimeViewModifier {
    public static var baseName: String { "searchScopes" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse selection binding (required, first argument)
        guard let selectionArg = syntax.arguments.first,
              let selection = NodeBinding<String>(syntax: selectionArg.expression) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "SearchScopesModifier", argument: "selection")
        }

        // Try to parse variant with activation: searchScopes($selection, activation: .onTextEntry, scopes: template)
        if #available(iOS 16.4, macOS 13.3, tvOS 16.4, *) {
            if let activationArg = syntax.argument(named: "activation"),
               let activation = SearchScopeActivation(syntax: activationArg.expression),
               let scopesArg = syntax.argument(named: "scopes"),
               let scopes = ViewReference<Library>(syntax: scopesArg.expression) {
                self = .searchScopesWithActivation(selection: selection, activation: activation, scopes: scopes)
                return
            }
        }

        // Parse basic variant: searchScopes($selection, scopes: template)
        guard let scopesArg = syntax.argument(named: "scopes"),
              let scopes = ViewReference<Library>(syntax: scopesArg.expression) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "SearchScopesModifier", argument: "scopes")
        }

        self = .searchScopes(selection: selection, scopes: scopes)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        SearchScopesModifierBody<Library>(modifier: self, content: _content)
    }
}

/// Internal view that resolves NodeBinding to Binding at runtime using environment.
private struct SearchScopesModifierBody<Library: ElementLibrary>: View {
    let modifier: SearchScopesModifier<Library>
    let content: SearchScopesModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch modifier {
        case .searchScopes(let selection, let scopes):
            if #available(iOS 16.0, macOS 13.0, tvOS 16.4, *) {
                content.searchScopes(selection.binding(node: node, runtime: runtime)) {
                    scopes
                }
            } else {
                content
            }
        case .searchScopesWithActivation(let selection, let activation, let scopes):
            if #available(iOS 16.4, macOS 13.3, tvOS 16.4, *) {
                content.searchScopes(selection.binding(node: node, runtime: runtime), activation: activation) {
                    scopes
                }
            } else {
                content
            }
        }
    }
}

// MARK: - SearchScopeActivation SyntaxConvertible

@available(iOS 16.4, macOS 13.3, tvOS 16.4, *)
extension SearchScopeActivation: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else {
            return nil
        }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self = .automatic
        case "onTextEntry":
            self = .onTextEntry
        case "onSearchPresentation":
            self = .onSearchPresentation
        default:
            return nil
        }
    }
}
#endif
