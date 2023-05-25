//
//  ViewStylesModifiersTests.swift
//
//
//  Created by Dylan.Ginsburg on 5/23/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class TablesModifiersTests: XCTestCase {
    func testTableStyle() throws {
        #if os(iOS) || os(macOS)
        struct Row: Identifiable {
            let id = UUID()
            let name: String
            let description: String
            let length: String
        }
        let rows: [Row] = [
            .init(name: "a", description: "b", length: "c"),
            .init(name: "d", description: "e", length: "f"),
            .init(name: "g", description: "h", length: "i")
        ]
        let table = Table(rows) {
            TableColumn("Name", value: \.name)
            TableColumn("Description", value: \.description)
            TableColumn("Length", value: \.length)
        }
                
        let tableWithModifier = { (modifier: String) in
        #"""
        <Table modifiers='\#(modifier)'>
            <Group template="columns">
                <TableColumn id="name">Name</TableColumn>
                <TableColumn id="description">Description</TableColumn>
                <TableColumn id="length">Length</TableColumn>
            </Group>
            <Group template="rows">
                <TableRow id="basketball">
                    <Text>a</Text>
                    <Text>b</Text>
                    <Text>c</Text>
                </TableRow>
                <TableRow id="soccer">
                    <Text>d</Text>
                    <Text>e</Text>
                    <Text>f</Text>
                </TableRow>
                <TableRow id="football">
                    <Text>g</Text>
                    <Text>h</Text>
                    <Text>i</Text>
                </TableRow>
            </Group>
        </Table>
        """#
        }
        
        try assertMatch(
            tableWithModifier(
            #"""
            [{"style":"automatic","type":"table_style"}]
            """#
            ),
            size: .init(width: 500, height: 500)
        ) {
            table.tableStyle(.automatic)
        }
        try assertMatch(
            tableWithModifier(
            #"""
            [{"style":"inset","type":"table_style"}]
            """#
            ),
            size: .init(width: 500, height: 500)
        ) {
            table.tableStyle(.inset)
        }
        
        #if os(macOS)
        try assertMatch(
            tableWithModifier(
            #"""
            [{"style":"inset_alternates_row_backgrounds","type":"table_style"}]
            """#
            ),
            size: .init(width: 500, height: 500)
        ) {
            table.tableStyle(.inset(alternatesRowBackgrounds: true))
        }
        try assertMatch(
            tableWithModifier(
            #"""
            [{"style":"bordered","type":"table_style"}]
            """#
            ),
            size: .init(width: 500, height: 500)
        ) {
            table.tableStyle(.bordered)
        }
        try assertMatch(
            tableWithModifier(
            #"""
            [{"style":"bordered_alternates_row_backgrounds","type":"table_style"}]
            """#
            ),
            size: .init(width: 500, height: 500)
        ) {
            table.tableStyle(.bordered(alternatesRowBackgrounds: true))
        }
        #endif
        
        #endif
    }
}
