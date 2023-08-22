//
//  SearchCompletionModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/11/2023.
//

import SwiftUI

/// Sets a completion within a ``SearchSuggestionsModifier`` modifier body.
///
/// Use this modifier alongside the ``SearchSuggestionsModifier`` modifier to set the text or token completion for an element.
///
/// ```html
/// <Text modifiers={search_completion(completion: "text completion")}>text completion</Text>
/// <Text modifiers={search_completion(token: "custom")}>Custom Token</Text>
/// ```
///
/// ## Arguments
/// * ``completion``
/// * ``token``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SearchCompletionModifier: ViewModifier, Decodable {
    /// Sets the completion to a string value.
    ///
    /// - Note: ``token`` takes precedence over ``completion``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let completion: String?

    /// Sets the completion to a token.
    ///
    /// - Note: ``token`` takes precedence over ``completion``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let token: String?

    func body(content: Content) -> some View {
        if let token {
            content
                #if os(iOS) || os(macOS)
                .searchCompletion(SearchToken(token))
                #endif
        } else if let completion {
            content.searchCompletion(completion)
        }
    }
}
