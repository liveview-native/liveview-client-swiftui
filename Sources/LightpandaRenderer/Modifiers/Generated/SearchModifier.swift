import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for adding basic search functionality to views.
///
/// This is a simplified version of `searchable` that provides basic search with just a text binding.
/// For more advanced search features (placement, prompt, tokens), use `searchable` instead.
///
/// Usage:
/// - `.search(text: $searchText)` - basic search with binding
///
/// JavaScript integration:
/// ```javascript
/// // Listen for search text changes
/// element.addEventListener("searchtextchanged", (event) => {
///     console.log("Search text:", event.detail.value);
/// });
///
/// // Set search text
/// element.setAttribute("searchtext", "query");
/// ```
public enum SearchModifier<Library: ElementLibrary>: @unchecked Sendable {
    case search(text: NodeBinding<String>)
}

extension SearchModifier: RuntimeViewModifier {
    public static var baseName: String { "search" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse text binding (required)
        guard let textArg = syntax.argument(named: "text"),
              let text = NodeBinding<String>(syntax: textArg.expression) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "SearchModifier", argument: "text")
        }

        self = .search(text: text)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .search(let text):
            SearchModifierBody(text: text, content: _content)
        }
    }
}

/// Helper view that resolves the NodeBinding to a real Binding
private struct SearchModifierBody<Content: View>: View {
    let text: NodeBinding<String>
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.searchable(text: text.binding(node: node, runtime: runtime))
    }
}
