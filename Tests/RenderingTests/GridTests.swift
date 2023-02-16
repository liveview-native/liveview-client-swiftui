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
}
