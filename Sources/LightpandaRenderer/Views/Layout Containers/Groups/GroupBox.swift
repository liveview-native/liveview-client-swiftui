//
//  GroupBox.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI
import LightpandaClient

/// Visual grouping of elements.
///
/// Use the `label` and `content` children to create a group box.
///
/// ```html
/// <GroupBox>
///     <Text template={:label}>Edit Actions</Text>
///     <Group template={:content}>
///         <Button phx-click="arrange">Arrange</Button>
///         <Button phx-click="update">Update</Button>
///         <Button phx-click="remove">Remove</Button>
///     </Group>
/// </GroupBox>
/// ```
///
/// Alternatively, use the ``title`` attribute instead of the `label` child.
///
/// ```html
/// <GroupBox title="Edit Actions">
///     <Button phx-click="arrange">Arrange</Button>
///     <Button phx-click="update">Update</Button>
///     <Button phx-click="remove">Remove</Button>
/// </GroupBox>
/// ```
///
/// ## Attributes
/// * ``title``
///
/// ## Children
/// * `label` - Describes the content of the group box.
/// * `content` - The elements to group together.
@_documentation(visibility: public)
struct GroupBox<Library: ElementLibrary>: View {
    let node: Node

    /// The title to use.
    ///
    /// Takes precedence over a `label` child.
    @_documentation(visibility: public)
    private var title: String? {
        node.attributeValue(for: "title")
    }

    public var body: some View {
#if os(iOS) || os(macOS)
        SwiftUI.Group {
            if let title {
                SwiftUI.GroupBox(title) {
                    node.children(library: Library.self)
                }
            } else {
                SwiftUI.GroupBox {
                    node.children(in: "content", default: true, library: Library.self)
                } label: {
                    node.children(in: "label", library: Library.self)
                }
            }
        }
#endif
    }
}
