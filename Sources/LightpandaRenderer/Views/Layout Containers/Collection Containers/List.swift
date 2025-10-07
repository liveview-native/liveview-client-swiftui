//
//  List.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LightpandaClient

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
struct List<Library: ElementLibrary>: View {
    let node: Node
    
    #if os(iOS) || os(tvOS)
    @Environment(\.editMode) var editMode
    #endif
    
    // TODO: events
//    /// Event sent when a row is deleted.
//    ///
//    /// An event is sent with the `index` of the item to delete.
//    ///
//    /// ```html
//    /// <List phx-delete="on_delete">
//    ///     ...
//    /// </List>
//    /// ```
//    ///
//    /// ```elixir
//    /// defmodule MyAppWeb.SportsLive do
//    ///     def handle_event("on_delete", %{ "index" => index }, socket) do
//    ///         {:noreply, assign(socket, :items, List.delete_at(socket.assigns.items, index))}
//    ///     end
//    /// end
//    /// ```
//    @_documentation(visibility: public)
//    @Event("phx-delete", type: "click") private var delete
//    /// Event sent when a row is moved.
//    ///
//    /// An event is sent with the `index` of the item to move and its `destination` index.
//    ///
//    /// ```html
//    /// <List phx-move="on_move">
//    ///     ...
//    /// </List>
//    /// ```
//    ///
//    /// ```elixir
//    /// defmodule MyAppWeb.SportsLive do
//    ///     def handle_event("on_move", %{ "index" => index, "destination" => destination }, socket) do
//    ///         {element, list} = List.pop_at(socket.assigns.sports, index)
//    ///         moved = List.insert_at(list, (if destination > index, do: destination - 1, else: destination), element)
//    ///         {:noreply, assign(socket, :sports, moved)}
//    ///     end
//    /// end
//    /// ```
//    @_documentation(visibility: public)
//    @Event("phx-move", type: "click") private var move
//    
//    /// Synchronizes the selected rows with the server.
//    ///
//    /// To allow an arbitrary number of rows to be selected, use the `List` type for the value.
//    /// Use an empty list as the default value to start with no selection.
//    ///
//    /// To only allow a single selection, use the `String` type for the value.
//    /// Use `nil` as the default value to start with no selection.
//    @_documentation(visibility: public)
//    @ChangeTracked(attribute: "selection") private var selection = Selection.none
    
    public var body: some View {
        SwiftUI.List {
            node.children(library: Library.self)
        }
    }
}

private struct ListItemScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [String:CGFloat]
    
    static let defaultValue: Value = [:]
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}

struct TrackListItemScrollOffsetModifier: ViewModifier {
    let id: String
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    Rectangle()
                        .hidden()
                        .transformPreference(ListItemScrollOffsetPreferenceKey.self) { value in
                            value[id] = proxy.frame(in: .global).minY
                        }
                }
            }
    }
}

extension View {
    func trackListItemScrollOffset(id: String) -> some View {
        self.modifier(TrackListItemScrollOffsetModifier(id: id))
    }
}
