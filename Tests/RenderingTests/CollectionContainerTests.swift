//
//  CollectionContainerTests.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class CollectionContainerTests: XCTestCase {
    // MARK: List
    
    func testList() throws {
        try assertMatch(
            #"""
            <list>
                <text id="0">0</text>
                <text id="1">1</text>
                <text id="2">2</text>
            </list>
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
        let content = #"<text id="0">0</text><text id="1">1</text><text id="2">2</text>"#
        let list = List {
            Text("0")
            Text("1")
            Text("2")
        }
        try assertMatch(
            #"""
            <list list-style="automatic">\#(content)</list>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            list.listStyle(.automatic)
        }
        try assertMatch(
            #"""
            <list list-style="plain">\#(content)</list>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            list.listStyle(.plain)
        }
#if os(iOS) || os(macOS)
        try assertMatch(
            #"""
            <list list-style="sidebar">\#(content)</list>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            list.listStyle(.sidebar)
        }
        try assertMatch(
            #"""
            <list list-style="inset">\#(content)</list>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            list.listStyle(.inset)
        }
#endif
#if os(iOS)
        try assertMatch(
            #"""
            <list list-style="inset-grouped">\#(content)</list>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            list.listStyle(.insetGrouped)
        }
#endif
#if os(iOS) || os(tvOS)
        try assertMatch(
            #"""
            <list list-style="grouped">\#(content)</list>
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
            <section>
                <section:header>Header</section:header>
                <section:content>Content</section:content>
                <section:footer>Footer</section:footer>
            </section>
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
            <section>
                <section:header>Header</section:header>
                Content
                <section:footer>Footer</section:footer>
            </section>
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
    func testTable() throws {
        struct Item: Identifiable {
            let id: Int
            var a: String { "A\(id)" }
            var b: String { "B\(id)" }
            var c: String { "C\(id)" }
        }
        try assertMatch(
            #"""
            <table>
                <table:columns>
                    <table-column>A</table-column>
                    <table-column>B</table-column>
                    <table-column>C</table-column>
                </table:columns>
                <table:rows>
                    <table-row id="1">
                        <text>A1</text>
                        <text>B1</text>
                        <text>C1</text>
                    </table-row>
                    <table-row id="2">
                        <text>A2</text>
                        <text>B2</text>
                        <text>C2</text>
                    </table-row>
                    <table-row id="3">
                        <text>A3</text>
                        <text>B3</text>
                        <text>C3</text>
                    </table-row>
                </table:rows>
            </table>
            """#,
            environment: { environment in
                environment.horizontalSizeClass = .regular
                environment.verticalSizeClass = .regular
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
}
