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
}
