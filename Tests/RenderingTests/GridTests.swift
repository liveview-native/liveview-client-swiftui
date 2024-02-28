//
//  GridTests.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class GridTests: XCTestCase {
    func testGrid() throws {
        try assertMatch(
            #"""
            <Grid>
                <GridRow alignment="top">
                    <Text>Row 1</Text>
                    <Rectangle fillColor="system-red" />
                </GridRow>
                <Divider />
                <GridRow>
                    <Text>Row 2</Text>
                    <Rectangle fillColor="system-green" />
                    <Rectangle fillColor="system-green" />
                </GridRow>
                <Divider />
                <GridRow alignment="bottom">
                    <Text>Row 3</Text>
                    <Rectangle fillColor="system-blue" />
                    <Rectangle fillColor="system-blue" />
                    <Rectangle fillColor="system-blue" />
                </GridRow>
            </Grid>
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
        let fixed = "{\"size\":{\"fixed\":30},\"alignment\":\"topLeading\",\"spacing\":3}"
        let flexible = "{\"size\":{\"flexible\":{\"maximum\":100,\"minimum\":0}},\"alignment\":\"center\",\"spacing\":1}"
        let staticFlexible = "{\"size\":\"flexible\",\"alignment\":\"bottomTrailing\"}"
        let adaptive = "{\"size\":{\"adaptive\":{\"minimum\":10}}}"
        
        let columns = "[\(fixed),\(flexible),\(staticFlexible),\(adaptive)]".replacingOccurrences(of: "\"", with: "&quot;")
        
        try assertMatch(
            #"""
            <LazyVGrid columns="\#(columns)">
                <Rectangle />
                <Rectangle />
                <Rectangle />
                <Rectangle />
                <Rectangle />
                <Rectangle />
            </LazyVGrid>
            """#,
            size: .init(width: 500, height: 500)
        ) {
            LazyVGrid(columns: [
                .init(.fixed(30), spacing: 3, alignment: .topLeading),
                .init(.flexible(minimum: 0, maximum: 100), spacing: 1, alignment: .center),
                .init(.flexible(), alignment: .bottomTrailing),
                .init(.adaptive(minimum: 10)),
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
        let fixed = "{\"size\":{\"fixed\":30},\"alignment\":\"topLeading\",\"spacing\":3}"
        let flexible = "{\"size\":{\"flexible\":{\"maximum\":100,\"minimum\":0}},\"alignment\":\"center\",\"spacing\":1}"
        let staticFlexible = "{\"size\":\"flexible\",\"alignment\":\"bottomTrailing\"}"
        let adaptive = "{\"size\":{\"adaptive\":{\"minimum\":10}}}"
        
        let rows = "[\(fixed),\(flexible),\(staticFlexible),\(adaptive)]".replacingOccurrences(of: "\"", with: "&quot;")
        
        try assertMatch(
            #"""
            <LazyHGrid rows="\#(rows)">
                <Rectangle />
                <Rectangle />
                <Rectangle />
                <Rectangle />
                <Rectangle />
                <Rectangle />
            </LazyHGrid>
            """#,
            size: .init(width: 500, height: 500)
        ) {
            LazyHGrid(rows: [
                .init(.fixed(30), spacing: 3, alignment: .topLeading),
                .init(.flexible(minimum: 0, maximum: 100), spacing: 1, alignment: .center),
                .init(.flexible(), alignment: .bottomTrailing),
                .init(.adaptive(minimum: 10)),
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
