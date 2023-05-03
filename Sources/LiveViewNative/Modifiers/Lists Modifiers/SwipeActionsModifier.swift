//
//  SwipeActionsModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 5/1/23.
//

import SwiftUI

/// Adds custom swipe actions to any item within a list.
///
/// Nested content is referenced by its namespace using the `content` argument.
///
/// ```html
/// <List id="swipe_actions_example">
///   <%= for item <- @items do %>
///     <HStack
///       id={@item.id}
///       modifiers={
///         @native
///         |> swipe_actions(edge: :trailing, allows_full_swipe: false, content: :delete)
///         |> swipe_actions(edge: :trailing, allows_full_swipe: false, content: :flag)
///       }>
///       <Text><%= item %></Text>
///       <swipe_actions:flag>
///         <Button phx-click="flag_item" phx-value-item-id={@item.id}>
///           <Image system-name="flag" />
///         </Button>
///       </swipe_actions:flag>
///       <swipe_actions:delete>
///         <Button phx-click="delete_item" phx-value-item-id={@item.id} modifiers={tint(@native, color: :red)}>
///           <Image system-name="trash" />
///         </Button>
///       </swipe_actions:delete>
///     </HStack>
///   <% end %>
/// </List>
///
/// ## Arguments
/// * ``allowsFullSwipe``
/// * ``content``
/// * ``edge``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SwipeActionsModifier<R: RootRegistry>: ViewModifier, Decodable {
    @ObservedElement private var element
    @LiveContext<R> private var context
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    /// The edge of the list item to associate the swipe actions with.
    let edge: HorizontalEdge
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    /// A boolean value that indicates whether the swipe action should be allowed to span the entire width of the screen.
    let allowsFullSwipe: Bool
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    /// The content of the swipe action.
    let content: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decodeIfPresent(String.self, forKey: .edge) {
        case "leading":
            self.edge = .leading
        default:
            self.edge = .trailing
        }
        self.allowsFullSwipe = try container.decode(Bool.self, forKey: .allowsFullSwipe)
        self.content = try container.decode(String.self, forKey: .content)
    }

    func body(content: Content) -> some View {
        content.swipeActions(edge: edge, allowsFullSwipe: allowsFullSwipe) {
            context.buildChildren(of: element, withTagName: self.content, namespace: "swipe_actions")
        }
    }

    enum CodingKeys: String, CodingKey {
        case allowsFullSwipe
        case content
        case edge
    }
}
