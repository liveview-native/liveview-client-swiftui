//
//  GroupBox.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI

/// Visual grouping of elements.
///
/// Use the `label` and `content` children to create a group box.
///
/// ```html
/// <GroupBox>
///     <GroupBox:label>
///         Edit Actions
///     </GroupBox:label>
///     <GroupBox:content>
///         <Button phx-click="arrange">Arrange</Button>
///         <Button phx-click="update">Update</Button>
///         <Button phx-click="remove">Remove</Button>
///     </GroupBox:content>
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
/// * ``style``
///
/// ## Children
/// * `label` - Describes the content of the group box.
/// * `content` - The elements to group together.
///
/// ## Topics
/// ### Supporting Types
/// - ``GroupBoxStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct GroupBox<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The title to use.
    ///
    /// Takes precedence over a `label` child.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("title") private var title: String?
    /// The style to apply to this group box.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("group-box-style") private var style: GroupBoxStyle = .automatic

    public var body: some View {
#if os(iOS) || os(macOS)
        SwiftUI.Group {
            if let title {
                SwiftUI.GroupBox(title) {
                    context.buildChildren(of: element)
                }
            } else {
                SwiftUI.GroupBox {
                    context.buildChildren(of: element, forTemplate: "content", includeDefaultSlot: true)
                } label: {
                    context.buildChildren(of: element, forTemplate: "label")
                }
            }
        }
        .applyGroupBoxStyle(style)
#endif
    }
}

#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum GroupBoxStyle: String, AttributeDecodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
}

fileprivate extension View {
    @ViewBuilder
    func applyGroupBoxStyle(_ style: GroupBoxStyle) -> some View {
#if os(iOS) || os(macOS)
        switch style {
        case .automatic:
            self.groupBoxStyle(.automatic)
        }
#endif
    }
}
