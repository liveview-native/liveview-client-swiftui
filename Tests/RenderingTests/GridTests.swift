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
        try assertMatch(
            #"""
            <LazyVGrid columns="[{&quot;fixed&quot;:null,&quot;adaptive&quot;:null,&quot;flexible&quot;:{&quot;minimum&quot;:10,&quot;maximum&quot;:100},&quot;spacing&quot;:8,&quot;alignment&quot;:&quot;center&quot;},{&quot;flexible&quot;:null,&quot;adaptive&quot;:null,&quot;fixed&quot;:50,&quot;spacing&quot;:16,&quot;alignment&quot;:&quot;trailing&quot;}]">
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
            <LazyHGrid rows="[{&quot;fixed&quot;:null,&quot;adaptive&quot;:null,&quot;flexible&quot;:{&quot;minimum&quot;:10,&quot;maximum&quot;:100},&quot;spacing&quot;:8,&quot;alignment&quot;:&quot;center&quot;},{&quot;flexible&quot;:null,&quot;adaptive&quot;:null,&quot;fixed&quot;:50,&quot;spacing&quot;:16,&quot;alignment&quot;:&quot;trailing&quot;}]">
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
