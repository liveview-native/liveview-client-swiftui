//
//  Table.swift
//
//
//  Created by Carson Katri on 2/21/23.
//

import SwiftUI
import LightpandaClient

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
///     <Group template="columns">
///         <TableColumn id="name">Name</TableColumn>
///         <TableColumn id="description">Description</TableColumn>
///         <TableColumn id="length">Length</TableColumn>
///     </Group>
///     <Group template="rows">
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
///     </Group>
/// </Table>
/// ```
///
/// ## Children
/// * `columns` - Up to 10 `<TableColumn>` elements that describe the possible columns.
/// * `rows` -  An arbitrary number of `<TableRow>` elements, each with a unique `id` attribute.
@_documentation(visibility: public)
struct Table<Library: ElementLibrary>: View {
    let node: Node
    
    public var body: some View {
        #if os(iOS) || os(macOS)
        table(rows: self.rows, columns: self.columns)
        #endif
    }
    
    #if os(iOS) || os(macOS)
    @ViewBuilder
    private func table(rows: [TableRow], columns: [TableColumn<TableRow, Never, some View, SwiftUI.Text>]) -> some View {
        switch columns.count {
        case 1:
            SwiftUI.Table(rows) {
                columns[0]
            }
        case 2:
            SwiftUI.Table(rows) {
                columns[0]
                columns[1]
            }
        case 3:
            SwiftUI.Table(rows) {
                columns[0]
                columns[1]
                columns[2]
            }
        case 4:
            SwiftUI.Table(rows) {
                columns[0]
                columns[1]
                columns[2]
                columns[3]
            }
        case 5:
            SwiftUI.Table(rows) {
                columns[0]
                columns[1]
                columns[2]
                columns[3]
                columns[4]
            }
        case 6:
            SwiftUI.Table(rows) {
                columns[0]
                columns[1]
                columns[2]
                columns[3]
                columns[4]
                columns[5]
            }
        case 7:
            SwiftUI.Table(rows) {
                columns[0]
                columns[1]
                columns[2]
                columns[3]
                columns[4]
                columns[5]
                columns[6]
            }
        case 8:
            SwiftUI.Table(rows) {
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
            SwiftUI.Table(rows) {
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
            SwiftUI.Table(rows) {
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
            SwiftUI.Text("\(columns.count) is an invalid number of columns for <Table>. Only 1-10 columns are supported.")
                .foregroundStyle(.red)
        }
    }
    
    private var rows: [TableRow] {
        // First try to find rows in a group with template="rows"
        let templateRows = node.children
            .filter { $0.attributes["template"] == "rows" }
            .flatMap(\.children)
        
        // If no template group found, look for tablerow elements directly
        let directRows = templateRows.isEmpty ? node.children : templateRows
        
        return directRows.compactMap { child -> TableRow? in
            guard child.name.lowercased() == "tablerow",
                  child.attributeValue(for: "id") != nil else {
                return nil
            }
            return TableRow(node: child)
        }
    }
    
    private var columns: [TableColumn<TableRow, Never, some View, SwiftUI.Text>] {
        // First try to find columns in a group with template="columns"
        let templateColumns = node.children
            .filter { $0.attributes["template"] == "columns" }
            .flatMap(\.children)
        
        // If no template group found, look for tablecolumn elements directly
        let directColumns = templateColumns.isEmpty ? node.children : templateColumns
        
        let columnElements = directColumns.filter { $0.name.lowercased() == "tablecolumn" }
        
        let result: [TableColumn<TableRow, Never, some View, SwiftUI.Text>] = columnElements.enumerated().map { item in
            let label = item.element.children.first?.value ?? ""
            return TableColumn(label) { (row: TableRow) in
                let rowChildren = row.node.children
                if rowChildren.indices.contains(item.offset) {
                    NodeView<Library>(node: rowChildren[item.offset])
                }
            }
            .width(item.element.attributeValue(for: "width").flatMap(Double.init(_:)).flatMap(CGFloat.init))
            .width(
                min: item.element.attributeValue(for: "minWidth").flatMap(Double.init(_:)).flatMap(CGFloat.init),
                ideal: item.element.attributeValue(for: "idealWidth").flatMap(Double.init(_:)).flatMap(CGFloat.init),
                max: item.element.attributeValue(for: "maxWidth").flatMap(Double.init(_:)).flatMap(CGFloat.init)
            )
        }
        return result
    }
    #endif
}

#if os(iOS) || os(macOS)
fileprivate struct TableRow: Identifiable {
    let node: Node
    
    var id: String {
        guard let id = node.attributeValue(for: "id") else {
            preconditionFailure("<TableRow> must have an id")
        }
        return id
    }
}
#endif
