//
//  StackTests.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class StackTests: XCTestCase {
    func testVStack() throws {
        try assertMatch(
            #"""
            <v-stack>
                <text>A</text>
                <text>B</text>
                <text>C</text>
            </v-stack>
            """#
        ) {
            VStack {
                Text("A")
                Text("B")
                Text("C")
            }
        }
        try assertMatch(
            #"""
            <vstack>
                <text>A</text>
                <text>B</text>
                <text>C</text>
            </vstack>
            """#
        ) {
            VStack {
                Text("A")
                Text("B")
                Text("C")
            }
        }
    }
    
    func testHStack() throws {
        try assertMatch(
            #"""
            <h-stack>
                <text>A</text>
                <text>B</text>
                <text>C</text>
            </h-stack>
            """#
        ) {
            HStack {
                Text("A")
                Text("B")
                Text("C")
            }
        }
        try assertMatch(
            #"""
            <hstack>
                <text>A</text>
                <text>B</text>
                <text>C</text>
            </hstack>
            """#
        ) {
            HStack {
                Text("A")
                Text("B")
                Text("C")
            }
        }
    }
    
    func testZStack() throws {
        try assertMatch(
            #"""
            <z-stack>
                <text>A</text>
                <text>B</text>
                <text>C</text>
            </z-stack>
            """#
        ) {
            ZStack {
                Text("A")
                Text("B")
                Text("C")
            }
        }
        try assertMatch(
            #"""
            <zstack>
                <text>A</text>
                <text>B</text>
                <text>C</text>
            </zstack>
            """#
        ) {
            ZStack {
                Text("A")
                Text("B")
                Text("C")
            }
        }
    }
}
