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
        let rows = element.elementChildren().compactMap({ $0.tag == "table-row" ? Row(element: $0) : nil })
        let columns = columns(for: rows)
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
                SwiftUI.Text("Too many columns in table: \(columns.count)")
            }
        }
    }
    
    private func columns(for rows: [Row]) -> [TableColumn<Row, Never, some View, SwiftUI.Text>] {
        print(rows)
        let columns = rows.reduce([String]()) { partialResult, row in
            let columns = row.element.elementChildren().compactMap({ $0.tag == "table-column" ? $0.attributeValue(for: "id") : nil })
                .filter({ !partialResult.contains($0) })
            return partialResult + columns
        }
        print(columns)
        return columns.map { column in
            TableColumn(column) { (row: Row) in
                context.coordinator.builder.fromNodes(
                    row.element.children().filter({
                        guard let element = $0.asElement() else { return false }
                        return element.tag == "table-column" && element.attributeValue(for: "id") == column
                    }).flatMap({ $0.children() }),
                    context: context
                )
            }
            .width(min: <#T##CGFloat?#>, ideal: <#T##CGFloat?#>, max: <#T##CGFloat?#>)
        }
    }
}
#endif
