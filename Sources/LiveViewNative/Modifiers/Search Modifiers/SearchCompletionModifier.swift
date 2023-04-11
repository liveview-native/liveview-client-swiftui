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
/// <Text modifiers={search_completion(@native, completion: "text completion")}>text completion</Text>
/// <Text modifiers={search_completion(@native, token: "custom")}>Custom Token</Text>
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.completion = try container.decodeIfPresent(String.self, forKey: .completion)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
    }

    func body(content: Content) -> some View {
        if let token {
            content.searchCompletion(SearchToken(token))
        } else if let completion {
            content.searchCompletion(completion)
        }
    }

    enum CodingKeys: String, CodingKey {
        case completion
        case token
    }
}