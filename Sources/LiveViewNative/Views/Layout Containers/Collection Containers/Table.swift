//
//  Table.swift
//
//
//  Created by Carson Katri on 2/21/23.
//

import SwiftUI

/// A container organized by rows and columns.
///
/// Use `<TableColumn>` elements in the `columns` child, and `<TableRow>` elements in the `rows` child to build the table's content.
///
/// Each `<TableRow>` should have the same number of children as columns in the table.
///
/// > Precondition: `<TableRow>` must have an `id` attribute.
///
/// ```html
/// <Table>
///     <Table:columns>
///         <TableColumn id="name">Name</TableColumn>
///         <TableColumn id="description">Description</TableColumn>
///         <TableColumn id="length">Length</TableColumn>
///     </Table:columns>
///     <Table:rows>
///         <TableRow id="basketball">
///             <Text>Basketball</Text>
///             <Text>Players attempt to throw a ball into an elevated basket.</Text>
///             <Text>48 min</Text>
///         </TableRow>
///         <TableRow id="soccer">
///             <Text>Soccer</Text>
///             <Text>Players attempt to kick a ball into a goal.</Text>
///             <Text>90 min</Text>
///         </TableRow>
///         <TableRow id="football">
///             <Text>Football</Text>
///             <Text>Players attempt to throw a ball into an end zone.</Text>
///             <Text>60 min</Text>
///         </TableRow>
///     </Table:rows>
/// </Table>
/// ```
///
/// ### Sorting Tables
/// Use the ``sortOrder`` binding to handle changes in the sorting options.
///
/// ```html
/// <Table sort-order="sports_sort_order">
///     ...
///     <Table:rows>
///         <%= for sport <- Enum.sort_by(
///             @sports,
///             fn sport -> sport[hd(@sports_sort_order)["id"]] end,
///             (if hd(@sports_sort_order)["order"], do: &</2, else: &>/2)
///         ) do %>
///             <TableRow id={sport["id"]}>
///                 <Text><%= sport["name"] %></Text>
///                 <Text><%= sport["description"] %></Text>
///                 <Text><%= sport["length"] %></Text>
///             </TableRow>
///         <% end %>
///     </Table:rows>
/// </Table>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.SportsLive do
///   native_binding :sports_sort_order, List, []
/// end
/// ```
///
/// ### Selecting Rows
/// Use the ``selection`` binding to synchronize the selected row(s) with the LiveView.
///
/// ```html
/// <Table selection="selected_sports">
///     ...
/// </Table>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.SportsLive do
///   native_binding :selected_sports, List, []
/// end
/// ```
///
/// ## Attributes
/// * ``style``
///
/// ## Bindings
/// * ``selection``
/// * ``sortOrder``
///
/// ## Children
/// * `columns` - Up to 10 `<TableColumn>` elements that describe the possible columns.
/// * `rows` -  An arbitrary number of `<TableRow>` elements, each with a unique `id` attribute.
///
/// ## Topics
/// ### Sorting Tables
/// * ``sortOrder``
///
/// ### Selecting Rows
/// * ``selection``
///
/// ### Supporting Types
/// - ``TableStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct Table<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    @Environment(\.coordinatorEnvironment) private var coordinatorEnvironment
    
    /// Synchronizes the selected rows with the server.
    ///
    /// To allow an arbitrary number of rows to be selected, use the `List` type for the binding.
    /// Use an empty list as the default value to start with no selection.
    ///
    /// ```elixir
    /// defmodule MyAppWeb.SportsLive do
    ///   native_binding :selected_sports, List, []
    /// end
    /// ```
    ///
    /// To only allow a single selection, use the `String` type for the binding.
    /// Use `nil` as the default value to start with no selection.
    ///
    /// ```elixir
    /// defmodule MyAppWeb.SportsLive do
    ///   native_binding :selected_sport, String, nil
    /// end
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding(attribute: "selection") private var selection = Selection.multiple([])
    /// Synchronizes the columns to sort by with the server.
    ///
    /// The order is serialized as a list of maps with an `id` and `order` property.
    ///
    /// ```json
    /// [
    ///     {
    ///         "id": string,
    ///         "order": boolean
    ///     },
    ///     ...
    /// ]
    /// ```
    ///
    /// The value of `id` matches the `id` attribute of the `<TableColumn>`, or its index if there is no `id` attribute.
    /// The value of `order` matches [`Foundation.SortOrder`](https://developer.apple.com/documentation/Foundation/SortOrder).
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding(attribute: "sort-order") private var sortOrder = [TableColumnSort]()
    
    /// The style to apply to this table.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("table-style") private var style: TableStyle = .automatic
    
    public var body: some View {
        #if os(iOS) || os(macOS)
        SwiftUI.Group {
            table(rows: self.rows, columns: self.columns)
        }
        .applyTableStyle(style)
        #endif
    }
    
    #if os(iOS) || os(macOS)
    @ViewBuilder
    private func table(rows: [TableRow], columns: [TableColumn<TableRow, TableColumnSort, some View, SwiftUI.Text>]) -> some View {
        switch columns.count {
        case 1:
            SwiftUI.Table(rows: rows, selection: $selection, sortOrder: $sortOrder) {
                columns[0]
            }
        case 2:
            SwiftUI.Table(rows: rows, selection: $selection, sortOrder: $sortOrder) {
                columns[0]
                columns[1]
            }
        case 3:
            SwiftUI.Table(rows: rows, selection: $selection, sortOrder: $sortOrder) {
                columns[0]
                columns[1]
                columns[2]
            }
        case 4:
            SwiftUI.Table(rows: rows, selection: $selection, sortOrder: $sortOrder) {
                columns[0]
                columns[1]
                columns[2]
                columns[3]
            }
        case 5:
            SwiftUI.Table(rows: rows, selection: $selection, sortOrder: $sortOrder) {
                columns[0]
                columns[1]
                columns[2]
                columns[3]
                columns[4]
            }
        case 6:
            SwiftUI.Table(rows: rows, selection: $selection, sortOrder: $sortOrder) {
                columns[0]
                columns[1]
                columns[2]
                columns[3]
                columns[4]
                columns[5]
            }
        case 7:
            SwiftUI.Table(rows: rows, selection: $selection, sortOrder: $sortOrder) {
                columns[0]
                columns[1]
                columns[2]
                columns[3]
                columns[4]
                columns[5]
                columns[6]
            }
        case 8:
            SwiftUI.Table(rows: rows, selection: $selection, sortOrder: $sortOrder) {
                columns[0]
                columns[1]
                columns[2]
                columns[3]
                columns[4]
                columns[5]
                columns[6]
                columns[7]
            }
        case 9:
            SwiftUI.Table(rows: rows, selection: $selection, sortOrder: $sortOrder) {
                columns[0]
                columns[1]
                columns[2]
                columns[3]
                columns[4]
                columns[5]
                columns[6]
                columns[7]
                columns[8]
            }
        case 10:
            SwiftUI.Table(rows: rows, selection: $selection, sortOrder: $sortOrder) {
                columns[0]
                columns[1]
                columns[2]
                columns[3]
                columns[4]
                columns[5]
                columns[6]
                columns[7]
                columns[8]
                columns[9]
            }
        default:
            ErrorView<R>(TableError.badColumnCount(columns.count))
        }
    }
    
    private var rows: [TableRow] {
        element.elementChildren()
            .filter { $0.tag == "rows" && $0.namespace == "Table" }
            .flatMap { $0.elementChildren() }
            .compactMap { $0.tag == "TableRow" && $0.attribute(named: "id") != nil ? TableRow(element: $0) : nil }
    }
    
    private var columns: [TableColumn<TableRow, TableColumnSort, some View, SwiftUI.Text>] {
        let columnElements = element.elementChildren()
            .filter { $0.tag == "columns" && $0.namespace == "Table" }
            .flatMap { $0.elementChildren() }
            .filter { $0.tag == "TableColumn" }
        return columnElements.enumerated().map { item in
            TableColumn(item.element.innerText(), sortUsing: TableColumnSort(id: item.element.attributeValue(for: "id") ?? String(item.offset), order: .forward)) { (row: TableRow) in
                let rowChildren = row.element.children()
                if rowChildren.indices.contains(item.offset) {
                    context.coordinator.builder.fromNodes(
                        [rowChildren[item.offset]],
                        context: context.storage
                    )
                    .environment(\.coordinatorEnvironment, coordinatorEnvironment)
                }
            }
            .width(item.element.attributeValue(for: "width").flatMap(Double.init(_:)).flatMap(CGFloat.init))
            .width(
                min: item.element.attributeValue(for: "min-width").flatMap(Double.init(_:)).flatMap(CGFloat.init),
                ideal: item.element.attributeValue(for: "ideal-width").flatMap(Double.init(_:)).flatMap(CGFloat.init),
                max: item.element.attributeValue(for: "max-width").flatMap(Double.init(_:)).flatMap(CGFloat.init)
            )
        }
    }
    #endif
}

enum TableError: LocalizedError {
    case badColumnCount(Int)
    
    var errorDescription: String? {
        switch self {
        case let .badColumnCount(count):
            return "\(count) is an invalid number of columns for <Table>. Only 1-10 columns are supported."
        }
    }
}

fileprivate struct TableRow: Identifiable {
    let element: ElementNode
    var id: String {
        guard let id = element.attributeValue(for: "id")
        else { preconditionFailure("<table-row> must have an id") }
        return id
    }
    
    init(element: ElementNode) {
        self.element = element
    }
}

fileprivate struct TableColumnSort: SortComparator, Codable, Equatable {
    let id: String
    var order: SortOrder
    
    func compare(_ lhs: TableRow, _ rhs: TableRow) -> ComparisonResult {
        .orderedSame
    }
}

#if os(iOS) || os(macOS)
fileprivate extension SwiftUI.Table where Value == TableRow, Rows == TableForEachContent<[TableRow]> {
    init(
        rows: [TableRow],
        selection: Binding<Selection>,
        sortOrder: Binding<[TableColumnSort]>,
        @TableColumnBuilder<TableRow, TableColumnSort> columns: () -> Columns
    ) {
        switch selection.wrappedValue {
        case .single(_):
            self.init(rows, selection: selection.single, sortOrder: sortOrder, columns: columns)
        case .multiple(_):
            self.init(rows, selection: selection.multiple, sortOrder: sortOrder, columns: columns)
        }
    }
}
#endif

#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum TableStyle: String, AttributeDecodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case inset
    
    /// `inset-alternating`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case insetAlternating = "inset-alternating"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case bordered
    /// `bordered-alternating`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case borderedAlternating = "bordered-alternating"

}

fileprivate extension View {
    @available(iOS 16.0, macOS 13.0, *)
    @ViewBuilder
    func applyTableStyle(_ style: TableStyle) -> some View {
        switch style {
        case .automatic:
            #if os(iOS) || os(macOS)
            self.tableStyle(.automatic)
            #endif
        case .inset:
            #if os(macOS)
            self.tableStyle(.inset(alternatesRowBackgrounds: false))
            #elseif os(iOS)
            self.tableStyle(.inset)
            #endif
        case .insetAlternating:
            #if os(macOS)
            self.tableStyle(.inset(alternatesRowBackgrounds: true))
            #endif
        case .bordered:
            #if os(macOS)
            self.tableStyle(.bordered(alternatesRowBackgrounds: false))
            #endif
        case .borderedAlternating:
            #if os(macOS)
            self.tableStyle(.bordered(alternatesRowBackgrounds: true))
            #endif
        }
    }
}
