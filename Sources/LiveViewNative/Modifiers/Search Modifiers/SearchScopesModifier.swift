//
//  SearchScopesModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/11/2023.
//

import SwiftUI

/// Enables search scopes for an element.
///
/// Use this modifier alongside the ``SearchableModifier`` modifier.
///
/// Create a ``LiveBinding`` to synchronize the selected scope with the server.
///
/// ```elixir
/// defmodule MyAppWeb.SearchLive do
///   native_binding :active_scope, String, "photos"
/// end
/// ```
///
/// Provide the name of this binding, as well as a list of elements with the ``TagModifier`` modifier to create the scopes.
///
/// ```html
/// <List
///     modifiers={
///         @native
///         |> searchable(...)
///         |> search_scopes(active: :active_scope, scopes: :scope_list)
///     }
/// >
///     ...
///     <search_scopes:scope_list>
///         <Text modifiers='[{"type":"tag","value":"photos"}]'>Photos</Text>
///         <Text modifiers='[{"type":"tag","value":"videos"}]'>Videos</Text>
///         <Text modifiers='[{"type":"tag","value":"screenshots"}]'>Screenshots</Text>
///     </search_scopes:scopes_list>
/// </List>
/// ```
///
/// ## Arguments
/// * ``active``
/// * ``activation``
/// * ``scopes``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SearchScopesModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// Synchronizes the active scope with the server.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding(attribute: "active") private var active: String?

    /// Indicates when the scope options are displayed.
    ///
    /// Possible values:
    /// * `automatic`
    /// * `on_search_presentation`
    /// * `on_text_entry`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let activation: String?
    
    @available(iOS 16.4, macOS 13.3, watchOS 9.4, *)
    private var searchScopeActivation: SearchScopeActivation {
        switch activation {
        case "automatic": return .automatic
        case "on_search_presentation": return .onSearchPresentation
        case "on_text_entry": return .onTextEntry
        default: return .automatic
        }
    }
    
    /// An atom that references the element containing the list of scopes.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let scopes: String
    
    @ObservedElement private var element
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self._active = try LiveBinding(decoding: .active, in: container)
        self.activation = try container.decodeIfPresent(String.self, forKey: .activation)
        self.scopes = try container.decode(String.self, forKey: .scopes)
    }

    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS)
        if #available(iOS 16.4, macOS 13.3, tvOS 16.4, *) {
            content.searchScopes($active, activation: searchScopeActivation) {
                context.buildChildren(of: element, withTagName: scopes, namespace: "search_scopes")
            }
        } else {
            content.searchScopes($active) {
                context.buildChildren(of: element, withTagName: scopes, namespace: "search_scopes")
            }
        }
        #else
        content
        #endif
    }

    enum CodingKeys: String, CodingKey {
        case active
        case activation
        case scopes
    }
}
