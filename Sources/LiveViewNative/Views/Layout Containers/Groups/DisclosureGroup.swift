//
//  DisclosureGroup.swift
//
//
//  Created by Carson Katri on 2/22/23.
//

import SwiftUI

/// An expandable section of content.
///
/// Use the `content` and `label` children to create a disclosure group.
///
/// ```html
/// <DisclosureGroup>
///     <DisclosureGroup:label>
///         Edit Actions
///     </DisclosureGroup:label>
///     <DisclosureGroup:content>
///         <Button phx-click="arrange">Arrange</Button>
///         <Button phx-click="update">Update</Button>
///         <Button phx-click="remove">Remove</Button>
///     </DisclosureGroup:content>
/// </DisclosureGroup>
/// ```
///
/// To synchronize the expansion state with the server, use the ``isExpanded`` binding.
///
/// ```html
/// <DisclosureGroup is-expanded="actions_option">
///     ...
/// </DisclosureGroup>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.EditorLive do
///     native_binding :actions_open, Atom, true
/// end
/// ```
///
/// ## Attributes
/// * ``style``
///
/// ## Bindings
/// * ``isExpanded``
///
/// ## Children
/// * `label` - Describes the content of the disclosure group.
/// * `content` - The elements below the fold.
///
/// ## Topics
/// ### Supporting Types
/// - ``DisclosureGroupStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct DisclosureGroup<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// Synchronizes the expansion state with the server.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding(attribute: "is-expanded") private var isExpanded = false

    public var body: some View {
#if os(iOS) || os(macOS)
        SwiftUI.DisclosureGroup(isExpanded: $isExpanded) {
            context.buildChildren(of: element, forTemplate: "content", includeDefaultSlot: true)
        } label: {
            context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: false)
        }
#endif
    }
}
