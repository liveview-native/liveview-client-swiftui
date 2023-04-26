//
//  SearchSuggestionsModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/11/2023.
//

import SwiftUI

/// Provide a list of suggested search completions.
///
/// The list of completions is referenced by its namespace using the `suggestions` argument.
///
/// Use the ``SearchCompletionModifier`` modifier on each child to set the completion content.
///
/// ```html
/// <List
///     modifiers={
///         @native
///             |> searchable(...)
///             |> search_suggestions(suggestions: :my_suggestions)
///     }
/// >
///     ...
///     <search_suggestions:my_suggestions>
///         <Text modifiers={search_completion(@native, completion: "text completion")}>text completion</Text>
///         <Text modifiers={search_completion(@native, token: "Custom")}>Custom Token</Text>
///     </search_suggestions:my_suggestions>
/// <List>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SearchSuggestionsModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// An atom that references the element containing the list of completions.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let suggestions: String

    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.suggestions = try container.decode(String.self, forKey: .suggestions)
    }

    func body(content: Content) -> some View {
        content.searchSuggestions {
            context.buildChildren(of: element, withTagName: suggestions, namespace: "search_suggestions")
        }
    }

    enum CodingKeys: String, CodingKey {
        case suggestions
    }
}
