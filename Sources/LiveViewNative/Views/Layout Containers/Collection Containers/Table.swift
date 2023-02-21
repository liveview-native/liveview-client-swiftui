//
//  Table.swift
//
//
//  Created by Carson Katri on 2/21/23.
//

#if !os(watchOS)
import SwiftUI

struct Table<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    struct Row: Identifiable {
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
    
    public var body: some View {
        let rows = element.elementChildren()
            .filter { $0.tag == "rows" && $0.namespace == "table" }
            .flatMap { $0.elementChildren() }
            .compactMap { $0.tag == "table-row" ? Row(element: $0) : nil }
        let columns = self.columns
        return SwiftUI.Group {
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
                fatalError("Too many columns in table: \(columns.count)")
            }
        }
    }
    
    private var columns: [TableColumn<Row, Never, some View, SwiftUI.Text>] {
        let columnElements = element.elementChildren()
            .filter { $0.tag == "columns" && $0.namespace == "table" }
            .flatMap{ $0.elementChildren() }
            .filter { $0.tag == "table-column" }
        return columnElements.enumerated().map { item in
            TableColumn(item.element.innerText()) { (row: Row) in
                let rowChildren = row.element.children()
                if rowChildren.indices.contains(item.offset) {
                    context.coordinator.builder.fromNodes(
                        [rowChildren[item.offset]],
                        context: context
                    )
                }
            }
        }
    }
}
#endif
