import SwiftUI
import SwiftSyntax

/// Modifier for adding search suggestions to searchable views.
///
/// Usage:
/// ```html
/// <list modifiers='searchable(text: $searchText).searchSuggestions(suggestions)'>
///     <text template="suggestions">Suggestion 1</text>
///     <text template="suggestions">Suggestion 2</text>
/// </list>
/// ```
///
/// Supports:
/// - `.searchSuggestions(viewReference)` - display suggestions from a template
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public enum SearchSuggestionsModifier<Library: ElementLibrary>: @unchecked Sendable {
    case searchSuggestions(suggestions: ViewReference<Library>)
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension SearchSuggestionsModifier: RuntimeViewModifier {
    public static var baseName: String { "searchSuggestions" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Parse the first argument as a ViewReference
        guard let suggestionsArg = syntax.arguments.first,
              let suggestions = ViewReference<Library>(syntax: suggestionsArg.expression) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "SearchSuggestionsModifier", argument: "suggestions")
        }

        self = .searchSuggestions(suggestions: suggestions)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .searchSuggestions(let suggestions):
            _content.searchSuggestions { suggestions }
        }
    }
}
