//
//  LayoutFundamentalsModifiersTests.swift
//
//
//  Created by Carson Katri on 5/4/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class LayoutFundamentalsModifiersTests: XCTestCase {
    func testGridCellAnchor() throws {
        try assertMatch(
            #"""
            <Grid>
                <GridRow>
                    <Text modifiers="[{&quot;anchor&quot;:{&quot;named&quot;:&quot;top_leading&quot;,&quot;x&quot;:null,&quot;y&quot;:null},&quot;type&quot;:&quot;grid_cell_anchor&quot;}]">A</Text>
                    <Rectangle fill-color="system-blue" />
                </GridRow>
                <GridRow>
                    <Rectangle fill-color="system-red" />
                </GridRow>
            </Grid>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Grid {
                GridRow {
                    Text("A")
                        .gridCellAnchor(.topLeading)
                    Rectangle()
                        .fill(.blue)
                }
                GridRow {
                    Rectangle()
                        .fill(.red)
                }
            }
        }
    }
    
    func testGridCellColumns() throws {
        try assertMatch(
            #"""
            <Grid>
                <GridRow>
                    <Rectangle fill-color="system-red" />
                    <Rectangle fill-color="system-green" />
                </GridRow>
                <GridRow>
                    <Rectangle fill-color="system-blue" modifiers="[{&quot;count&quot;:2,&quot;type&quot;:&quot;grid_cell_columns&quot;}]" />
                </GridRow>
            </Grid>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Grid {
                GridRow {
                    Rectangle()
                        .fill(.red)
                    Rectangle()
                        .fill(.green)
                }
                GridRow {
                    Rectangle()
                        .fill(.blue)
                        .gridCellColumns(2)
                }
            }
        }
    }
    
    func testGridCellUnsizedAxes() throws {
        try assertMatch(
            #"""
            <Grid>
                <GridRow>
                    <Text>A</Text>
                    <Text>B</Text>
                </GridRow>
                <GridRow>
                    <Text>C</Text>
                    <Rectangle fill-color="system-red" modifiers="[{&quot;axes&quot;:&quot;all&quot;,&quot;type&quot;:&quot;grid_cell_unsized_axes&quot;}]" />
                </GridRow>
            </Grid>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Grid {
                GridRow {
                    Text("A")
                    Text("B")
                }
                GridRow {
                    Text("C")
                    Rectangle()
                        .fill(.red)
                        .gridCellUnsizedAxes([.horizontal, .vertical])
                }
            }
        }
    }
    
    func testGridColumnAlignment() throws {
        try assertMatch(
            #"""
            <Grid>
                <GridRow>
                    <Text>A</Text>
                    <Text>B</Text>
                </GridRow>
                <GridRow>
                    <Text>C</Text>
                    <Rectangle fill-color="system-red" modifiers="[{&quot;guide&quot;:&quot;trailing&quot;,&quot;type&quot;:&quot;grid_column_alignment&quot;}]" />
                </GridRow>
            </Grid>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Grid {
                GridRow {
                    Text("A")
                    Text("B")
                }
                GridRow {
                    Text("C")
                    Rectangle()
                        .fill(.red)
                        .gridColumnAlignment(.trailing)
                }
            }
        }
    }
}
