//
//  List.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

/// Presents rows of elements.
///
/// Each element inside the list is given its own row.
///
/// - Precondition: Each child element must have a unique `id` attribute.
///
/// ```html
/// <List>
///     <%= for sport <- @sports do %>
///         <Text id={sport.id}><%= sport.name %></Text>
///     <% end %>
/// </List>
/// ```
///
/// ### Edit Mode
/// Use an <doc:EditButton> to enter edit mode. This will allow rows to be moved, selected, and deleted.
///
/// ```html
/// <EditButton />
/// <List> ... </List>
/// ```
///
/// ### Selecting Rows
/// Use the ``selection`` attribute to set the selected row(s).
///
/// ```html
/// <List selection={@selected_sports} phx-change="selection-changed">
///     ...
/// </List>
/// ```
///
/// ### Deleting and Moving Rows
/// Set an event name for the ``delete`` attribute to enable the system delete action.
///
/// An event is sent with the `index` of the item to delete.
///
/// ```html
/// <List phx-delete="on_delete">
///     ...
/// </List>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.SportsLive do
///     def handle_event("on_delete", %{ "index" => index }, socket) do
///         {:noreply, assign(socket, :items, List.delete_at(socket.assigns.items, index))}
///     end
/// end
/// ```
///
/// Use the ``move`` event to enable the system move actions.
///
/// An event is sent with the `index` of the item to move and its `destination` index.
///
/// ```html
/// <List phx-move="on_move">
///     ...
/// </List>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.SportsLive do
///     def handle_event("on_move", %{ "index" => index, "destination" => destination }, socket) do
///         {element, list} = List.pop_at(socket.assigns.sports, index)
///         moved = List.insert_at(list, (if destination > index, do: destination - 1, else: destination), element)
///         {:noreply, assign(socket, :sports, moved)}
///     end
/// end
/// ```
///
/// ## Attributes
/// * ``selection``
///
/// ## Events
/// * ``delete``
/// * ``move``
@_documentation(visibility: public)
struct List<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    #if os(iOS) || os(tvOS)
    @Environment(\.editMode) var editMode
    #endif
    
    /// Event sent when a row is deleted.
    ///
    /// An event is sent with the `index` of the item to delete.
    ///
    /// ```html
    /// <List phx-delete="on_delete">
    ///     ...
    /// </List>
    /// ```
    ///
    /// ```elixir
    /// defmodule MyAppWeb.SportsLive do
    ///     def handle_event("on_delete", %{ "index" => index }, socket) do
    ///         {:noreply, assign(socket, :items, List.delete_at(socket.assigns.items, index))}
    ///     end
    /// end
    /// ```
    @_documentation(visibility: public)
    @Event("phx-delete", type: "click") private var delete
    /// Event sent when a row is moved.
    ///
    /// An event is sent with the `index` of the item to move and its `destination` index.
    ///
    /// ```html
    /// <List phx-move="on_move">
    ///     ...
    /// </List>
    /// ```
    ///
    /// ```elixir
    /// defmodule MyAppWeb.SportsLive do
    ///     def handle_event("on_move", %{ "index" => index, "destination" => destination }, socket) do
    ///         {element, list} = List.pop_at(socket.assigns.sports, index)
    ///         moved = List.insert_at(list, (if destination > index, do: destination - 1, else: destination), element)
    ///         {:noreply, assign(socket, :sports, moved)}
    ///     end
    /// end
    /// ```
    @_documentation(visibility: public)
    @Event("phx-move", type: "click") private var move
    
    /// Synchronizes the selected rows with the server.
    ///
    /// To allow an arbitrary number of rows to be selected, use the `List` type for the value.
    /// Use an empty list as the default value to start with no selection.
    ///
    /// To only allow a single selection, use the `String` type for the value.
    /// Use `nil` as the default value to start with no selection.
    @_documentation(visibility: public)
    @ChangeTracked(attribute: "selection") private var selection = Selection.none
    
    public var body: some View {
        #if os(watchOS)
        SwiftUI.List {
            content
        }
        #else
        switch selection {
        case .multiple:
            SwiftUI.List(selection: $selection.multiple) {
                content
            }
        case .single,
             _ where element.attribute(named: "phx-change") != nil:
            SwiftUI.List(selection: $selection.single) {
                content
            }
        case .none:
            SwiftUI.List {
                content
            }
        }
        #endif
    }
    
    private var content: some View {
        forEach(nodes: context.children(of: element), context: context.storage)
            .onDelete(perform: onDeleteHandler)
            .onMove(perform: onMoveHandler)
    }
    
    private var onDeleteHandler: ((IndexSet) -> Void)? {
        guard delete.event != nil else { return nil }
        return { indices in
            var meta = element.buildPhxValuePayload()
            // todo: what about multiple indicies?
            meta["index"] = indices.first!
            delete(value: meta) {}
        }
    }
    
    private var onMoveHandler: ((IndexSet, Int) -> Void)? {
        guard move.event != nil else { return nil }
        return { indices, index in
            var meta = element.buildPhxValuePayload()
            meta["index"] = indices.first!
            meta["destination"] = index
            move(value: meta) {
                Task {
#if os(iOS) || os(tvOS)
                    // Workaround to fix items not following the order from the backend when changed during edit mode.
                    // Toggling edit modes forces it to follow the backend ordering.
                    // Toggles between `active`/`transient` instead of `active`/`inactive` so no transitions play.
                    if let initial = editMode?.wrappedValue {
                        editMode?.wrappedValue = initial == .transient ? .active : .transient
                        await MainActor.run {
                            editMode?.wrappedValue = initial
                        }
                    }
#endif
                }
            }
        }
    }
}
