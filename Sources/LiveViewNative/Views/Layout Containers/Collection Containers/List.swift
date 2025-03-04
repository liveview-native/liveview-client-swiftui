//
//  List.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LiveViewNativeCore

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
@LiveElement
struct List<Root: RootRegistry>: View {
    #if os(iOS) || os(tvOS)
    @LiveElementIgnored
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
    
    @LiveAttribute(.init(name: "phx-change")) var phxChange: String?
    
    private var id: String?
    
    @LiveElementIgnored
    @State
    private var didAttemptRestoration = false
    
    public var body: some View {
        ScrollViewReader { scrollProxy in
            SwiftUI.Group {
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
                    _ where phxChange != nil:
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
            .backgroundPreferenceValue(ListItemScrollOffsetPreferenceKey.self) { value in
                GeometryReader { proxy in
                    Rectangle()
                        .hidden()
                        .onChange(of: value) { newValue in
                            guard let id else { return }
                            // don't update the value until we first attempt restoring the existing value.
                            guard didAttemptRestoration else { return }
                            
                            let offset = proxy.frame(in: .global).minY
                            
                            guard let closestItem = newValue
                                .sorted(by: { abs($0.value - offset) < abs($1.value - offset) })
                                .first
                            else {
                                $liveElement.context.coordinator.session.scrollPositions[$liveElement.context.coordinator.session.navigationPath.count, default: [:]].removeValue(forKey: id)
                                return
                            }
                            
                            if let lowestY = newValue.sorted(by: { $0.value < $1.value }).first?.value,
                               lowestY > offset
                            {
                                // if the element with the lowest Y value is still below the top of the List, we are at the top.
                                // store nil so we don't restore and stay at the top.
                                $liveElement.context.coordinator.session.scrollPositions[$liveElement.context.coordinator.session.navigationPath.count, default: [:]].removeValue(forKey: id)
                            } else {
                                // update the stored scrollPosition in the ``LiveSessionCoordinator``
                                $liveElement.context.coordinator.session.scrollPositions[$liveElement.context.coordinator.session.navigationPath.count, default: [:]][id] = .id(closestItem.key)
                            }
                        }
                }
            }
            .opacity((id == nil || didAttemptRestoration) ? 1 : 0) // prevent flickering when restoring
            .task {
                defer { didAttemptRestoration = true }
                
                guard let id,
                      case let .id(restoreID) = $liveElement.context.coordinator.session.scrollPositions[$liveElement.context.coordinator.session.navigationPath.count, default: [:]][id]
                else { return }
                
                scrollProxy.scrollTo(restoreID, anchor: .top)
                
                // wait for the next runloop and try to scroll again
                // it seems that the scroll won't work if the elements are not laid-out yet
                try! await Task.sleep(for: .nanoseconds(0))
                
                scrollProxy.scrollTo(restoreID, anchor: .top)
            }
        }
    }

    private var content: some View {
        let elements = $liveElement.childNodes
            .filter {
                !$0.attributes().contains(where: { $0.name.namespace == nil && $0.name.name == "template" })
            }
            .map { (node) -> ForEachElement in
                if let element = node.asElement(),
                   let id = element.attributeValue(for: .init(name: "id"))
                {
                    return .keyed(node, id: id)
                } else {
                    return .unkeyed(node)
                }
            }
        return ForEach(elements) { childNode in
            if case let .nodeElement(element) = childNode.node.data(),
               element.name.name == "Section"
            {
                // `Section` will apply tracking to its own children
                ViewTreeBuilder<Root>.NodeView(node: childNode.node, context: $liveElement.context.storage)
            } else {
                ViewTreeBuilder<Root>.NodeView(node: childNode.node, context: $liveElement.context.storage)
                    .trackListItemScrollOffset(id: childNode.id)
            }
        }
            .onDelete(perform: onDeleteHandler)
            .onMove(perform: onMoveHandler)
    }

    private var onDeleteHandler: ((IndexSet) -> Void)? {
        guard delete.event != nil else { return nil }
        return { indices in
            var meta = $liveElement.element.buildPhxValuePayload()
            // todo: what about multiple indicies?
            meta["index"] = indices.first!
            delete(value: meta) {}
        }
    }
    
    private var onMoveHandler: ((IndexSet, Int) -> Void)? {
        guard move.event != nil else { return nil }
        return { indices, index in
            var meta = $liveElement.element.buildPhxValuePayload()
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
