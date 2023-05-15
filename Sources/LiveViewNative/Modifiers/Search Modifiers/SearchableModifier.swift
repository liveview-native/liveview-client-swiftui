//
//  SearchableModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/11/2023.
//

import SwiftUI

/// Add a system search bar.
///
/// Use a ``LiveBinding`` to synchronize the query.
///
/// ```html
/// <List modifiers={searchable(@native, text: :query)}>
///     ...
/// </List>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.SearchLive do
///   native_binding :query, :string, ""
/// end
/// ```
///
/// You are responsible for providing your own filtering logic.
///
/// ### Tokens
/// Tokens can be added alongside the query to provide extra filtering capabilities.
///
/// Create a separate `native_binding` for the tokens.
///
/// ```elixir
/// native_binding :my_tokens, List, []
/// ```
///
/// Provide the name of this binding to the ``tokens`` argument, and a list of suggested tokens to the [`suggested_tokens`](doc:SearchableModifier/suggestedTokens) argument.
///
/// Add a child element for each token to specify how it should be rendered.
///
/// - Note: You can use [`Phoenix.HTML.Tag.content_tag/2`](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Tag.html#content_tag/2) to dynamically render an element for each token.
///
/// ```html
/// <List
///     modifiers={
///         @native |> searchable(
///             text: :query,
///             tokens: :my_tokens,
///             suggested_tokens: ["cats", "dogs"]
///         )
///     }
/// >
///     ...
///     <Label template={:cats} system-image="pawprint.fill">Cats</Label>
///     <Label template={:dogs} system-image="pawprint">Dogs</Label>
/// </List>
/// ```
///
/// - Note: If `suggested_tokens` is non-empty, the results will not be displayed on iOS. One option is to only provide token suggestions if the query starts with a special character, such as `#`.
///
/// ## Arguments
/// * ``text``
/// * ``tokens``
/// * [`suggested_tokens`](doc:SearchableModifier/suggestedTokens)
/// * ``placement``
/// * ``prompt``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SearchableModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// Synchronizes the search query with the server.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding private var text: String

    /// A ``LiveBinding`` for any selected tokens.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding(attribute: "tokens") private var tokens: [SearchToken] = []
    
    /// `suggested_tokens`, a list of tokens to display.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let suggestedTokens: [SearchToken]?

    /// The placement of the search bar.
    ///
    /// Possible values:
    /// * `automatic`
    /// * `navigation_bar_drawer`
    /// * `navigation_bar_drawer_always`
    /// * `sidebar`
    /// * `toolbar`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let placement: SearchFieldPlacement

    /// A custom placeholder for the search field.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let prompt: SwiftUI.Text?
    
    @ObservedElement private var element
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self._text = try LiveBinding(decoding: .text, in: container)
        self._tokens = try LiveBinding(decoding: .tokens, in: container, initialValue: [])
        self.suggestedTokens = try container.decodeIfPresent([SearchToken].self, forKey: .suggestedTokens)
        
        switch try container.decodeIfPresent(String.self, forKey: .placement) ?? "automatic" {
        case "automatic": self.placement = .automatic
        #if os(iOS) || os(watchOS)
        case "navigation_bar_drawer": self.placement = .navigationBarDrawer
        #endif
        #if os(iOS)
        case "navigation_bar_drawer_always": self.placement = .navigationBarDrawer(displayMode: .always)
        #endif
        #if os(iOS) || os(macOS)
        case "sidebar": self.placement = .sidebar
        #endif
        case "toolbar": self.placement = .toolbar
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "unknown placement '\(`default`)'"))
        }

        self.prompt = try container.decodeIfPresent(String.self, forKey: .prompt).flatMap(SwiftUI.Text.init)
    }

    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS)
        if let suggestedTokens {
            content
                .searchable(text: $text, tokens: $tokens, suggestedTokens: .constant(suggestedTokens), placement: placement, prompt: prompt) { token in
                    context.buildChildren(of: element, forTemplate: token.value)
                }
        } else {
            content
                .searchable(text: $text, tokens: $tokens, placement: placement, prompt: prompt) { token in
                    context.buildChildren(of: element, forTemplate: token.value)
                }
        }
        #else
        content.searchable(text: $text, placement: placement, prompt: prompt)
        #endif
    }

    enum CodingKeys: String, CodingKey {
        case text
        case tokens
        case suggestedTokens
        case placement
        case prompt
        case token
    }
}

struct SearchToken: Identifiable, Codable {
    let value: String
    var id: String { value }
    
    init(_ value: String) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        self.value = try decoder.singleValueContainer().decode(String.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
