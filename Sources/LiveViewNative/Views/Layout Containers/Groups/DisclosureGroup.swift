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
///     <Text template={:label}>Edit Actions</Text>
///     <Group template={:content}>
///         <Button phx-click="arrange">Arrange</Button>
///         <Button phx-click="update">Update</Button>
///         <Button phx-click="remove">Remove</Button>
///     </Group>
/// </DisclosureGroup>
/// ```
///
/// To synchronize the expansion state with the server, use the ``isExpanded`` attribute.
///
/// ```html
/// <DisclosureGroup isExpanded={@actions_open} phx-change="actions-group-changed">
///     ...
/// </DisclosureGroup>
/// ```
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
@_documentation(visibility: public)
@available(iOS 16.0, macOS 13.0, *)
@LiveElement
struct DisclosureGroup<Root: RootRegistry>: View {
    /// Synchronizes the expansion state with the server.
    @_documentation(visibility: public)
    @ChangeTracked(attribute: "isExpanded") private var isExpanded = false

    public var body: some View {
#if os(iOS) || os(macOS)
        SwiftUI.DisclosureGroup(isExpanded: $isExpanded) {
            $liveElement.children(in: "content", default: true)
        } label: {
            $liveElement.children(in: "label")
        }
#endif
    }
}
