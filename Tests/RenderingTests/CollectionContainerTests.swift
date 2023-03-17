//
//  CollectionContainerTests.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class CollectionContainerTests: XCTestCase {
    // MARK: List
    
    func testList() throws {
        try assertMatch(
            #"""
            <List>
                <Text id="0">0</Text>
                <Text id="1">1</Text>
                <Text id="2">2</Text>
            </List>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            List {
                Text("0")
                Text("1")
                Text("2")
            }
        }
    }
    func testListStyles() throws {
        let content = #"<Text id="0">0</Text><Text id="1">1</Text><Text id="2">2</Text>"#
        let list = List {
            Text("0")
            Text("1")
            Text("2")
        }
        try assertMatch(
            #"""
            <List list-style="automatic">\#(content)</List>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            list.listStyle(.automatic)
        }
        try assertMatch(
            #"""
            <List list-style="plain">\#(content)</List>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            list.listStyle(.plain)
        }
#if os(iOS) || os(macOS)
        try assertMatch(
            #"""
            <List list-style="sidebar">\#(content)</List>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            list.listStyle(.sidebar)
        }
        try assertMatch(
            #"""
            <List list-style="inset">\#(content)</List>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            list.listStyle(.inset)
        }
#endif
#if os(iOS)
        try assertMatch(
            #"""
            <List list-style="inset-grouped">\#(content)</List>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            list.listStyle(.insetGrouped)
        }
#endif
#if os(iOS) || os(tvOS)
        try assertMatch(
            #"""
            <List list-style="grouped">\#(content)</List>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            list.listStyle(.grouped)
        }
#endif
    }
    
    // MARK: Section
    
    func testSection() throws {
        try assertMatch(
            #"""
            <Section>
                <Section:header>Header</Section:header>
                <Section:content>Content</Section:content>
                <Section:footer>Footer</Section:footer>
            <Section>
            """#
        ) {
            Section {
                Text("Content")
            } header: {
                Text("Header")
            } footer: {
                Text("Footer")
            }
        }
        try assertMatch(
            #"""
            <Section>
                <Section:header>Header</Section:header>
                Content
                <Section:footer>Footer</Section:footer>
            </Section>
            """#
        ) {
            Section {
                Text("Content")
            } header: {
                Text("Header")
            } footer: {
                Text("Footer")
            }
        }
    }
    
    // MARK: Table
#if os(iOS) || os(macOS)
    func testTable() throws {
        struct Item: Identifiable {
            let id: Int
            var a: String { "A\(id)" }
            var b: String { "B\(id)" }
            var c: String { "C\(id)" }
        }
        try assertMatch(
            #"""
            <Table>
                <Table:columns>
                    <TableColumn>A</TableColumn>
                    <TableColumn>B</TableColumn>
                    <TableColumn>C</TableColumn>
                </Table:columns>
                <Table:rows>
                    <TableRow id="1">
                        <Text>A1</Text>
                        <Text>B1</Text>
                        <Text>C1</Text>
                    </TableRow>
                    <TableRow id="2">
                        <Text>A2</Text>
                        <Text>B2</Text>
                        <Text>C2</Text>
                    </TableRow>
                    <TableRow id="3">
                        <Text>A3</Text>
                        <Text>B3</Text>
                        <Text>C3</Text>
                    </TableRow>
                </Table:rows>
            </Table>
            """#,
            environment: { environment in
                #if os(iOS)
                environment.horizontalSizeClass = .regular
                environment.verticalSizeClass = .regular
                #endif
            },
            size: .init(width: 600, height: 500)
        ) {
            Table(of: Item.self) {
                TableColumn("A", value: \.a)
                TableColumn("B", value: \.b)
                TableColumn("C", value: \.c)
            } rows: {
                TableRow(Item(id: 1))
                TableRow(Item(id: 2))
                TableRow(Item(id: 3))
            }
        }
    }
#endif
}
