//
//  GridTests.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class GridTests: XCTestCase {
    func testGrid() throws {
        try assertMatch(
            #"""
            <grid>
                <grid-row alignment="top">
                    <text>Row 1</text>
                    <rectangle fill-color="system-red" />
                </grid-row>
                <divider />
                <grid-row>
                    <text>Row 2</text>
                    <rectangle fill-color="system-green" />
                    <rectangle fill-color="system-green" />
                </grid-row>
                <divider />
                <grid-row alignment="bottom">
                    <text>Row 3</text>
                    <rectangle fill-color="system-blue" />
                    <rectangle fill-color="system-blue" />
                    <rectangle fill-color="system-blue" />
                </grid-row>
            </grid>
            """#,
            size: .init(width: 400, height: 400)
        ) {
            Grid {
                GridRow(alignment: .top) {
                    Text("Row 1")
                    Rectangle().fill(.red)
                }
                Divider()
                GridRow {
                    Text("Row 2")
                    Rectangle().fill(.green)
                    Rectangle().fill(.green)
                }
                Divider()
                GridRow(alignment: .bottom) {
                    Text("Row 3")
                    Rectangle().fill(.blue)
                    Rectangle().fill(.blue)
                    Rectangle().fill(.blue)
                }
            }
        }
    }
    
    // MARK: Lazy Grids
    func testLazyVGrid() throws {
        try assertMatch(
            #"""
            <lazy-v-grid columns="[{&quot;fixed&quot;:null,&quot;adaptive&quot;:null,&quot;flexible&quot;:{&quot;minimum&quot;:10,&quot;maximum&quot;:100},&quot;spacing&quot;:8,&quot;alignment&quot;:&quot;center&quot;},{&quot;flexible&quot;:null,&quot;adaptive&quot;:null,&quot;fixed&quot;:50,&quot;spacing&quot;:16,&quot;alignment&quot;:&quot;trailing&quot;}]">
                <rectangle />
                <rectangle />
                <rectangle />
                <rectangle />
                <rectangle />
                <rectangle />
            </lazy-v-grid>
            """#,
            size: .init(width: 500, height: 500)
        ) {
            LazyVGrid(columns: [
                .init(.flexible(minimum: 10, maximum: 100), spacing: 8, alignment: .center),
                .init(.fixed(50), spacing: 16, alignment: .trailing),
            ]) {
                Rectangle()
                Rectangle()
                Rectangle()
                Rectangle()
                Rectangle()
                Rectangle()
            }
        }
    }
    
    func testLazyHGrid() throws {
        try assertMatch(
            #"""
            <lazy-h-grid rows="[{&quot;fixed&quot;:null,&quot;adaptive&quot;:null,&quot;flexible&quot;:{&quot;minimum&quot;:10,&quot;maximum&quot;:100},&quot;spacing&quot;:8,&quot;alignment&quot;:&quot;center&quot;},{&quot;flexible&quot;:null,&quot;adaptive&quot;:null,&quot;fixed&quot;:50,&quot;spacing&quot;:16,&quot;alignment&quot;:&quot;trailing&quot;}]">
                <rectangle />
                <rectangle />
                <rectangle />
                <rectangle />
                <rectangle />
                <rectangle />
            </lazy-h-grid>
            """#,
            size: .init(width: 500, height: 500)
        ) {
            LazyHGrid(rows: [
                .init(.flexible(minimum: 10, maximum: 100), spacing: 8, alignment: .center),
                .init(.fixed(50), spacing: 16, alignment: .trailing),
            ]) {
                Rectangle()
                Rectangle()
                Rectangle()
                Rectangle()
                Rectangle()
                Rectangle()
            }
        }
    }
}
