//
//  Table.swift
//
//
//  Created by Carson Katri on 2/21/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

struct Table<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    @Environment(\.coordinatorEnvironment) private var coordinatorEnvironment
    
    @LiveBinding(attribute: "selection") private var selection = Selection.multiple([])
    @LiveBinding(attribute: "sort-order") private var sortOrder = [TableColumnSort]()
    
    @Attribute("table-style") private var style: TableStyle = .automatic
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        let rows = element.elementChildren()
            .filter { $0.tag == "rows" && $0.namespace == "Table" }
            .flatMap { $0.elementChildren() }
            .compactMap { $0.tag == "TableRow" ? TableRow(element: $0) : nil }
        let columns = self.columns
        return SwiftUI.Group {
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
                fatalError("Too many columns in table: \(columns.count)")
            }
        }
        .applyTableStyle(style)
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
                        context: context
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

fileprivate enum TableStyle: String, AttributeDecodable {
    case automatic
    case inset
    #if os(macOS)
    case insetAlternating = "inset-alternating"
    case bordered
    case borderedAlternating = "bordered-alternating"
    #endif
}

fileprivate extension View {
    @ViewBuilder
    func applyTableStyle(_ style: TableStyle) -> some View {
        switch style {
        case .automatic:
            self.tableStyle(.automatic)
        case .inset:
#if os(macOS)
            self.tableStyle(.inset(alternatesRowBackgrounds: false))
#else
            self.tableStyle(.inset)
#endif
#if os(macOS)
        case .insetAlternating:
            self.tableStyle(.inset(alternatesRowBackgrounds: true))
        case .bordered:
            self.tableStyle(.bordered(alternatesRowBackgrounds: false))
        case .borderedAlternating:
            self.tableStyle(.bordered(alternatesRowBackgrounds: true))
#endif
        }
    }
}

#endif
