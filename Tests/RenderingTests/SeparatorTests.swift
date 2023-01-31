//
//  SeparatorTests.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class SeparatorTests: XCTestCase {
    func testSpacer() throws {
        try assertMatch(
            #"""
            <h-stack>
                <text>A</text>
                <spacer />
                <text>B</text>
            </h-stack>
            """#,
            size: .init(width: 100, height: 50)
        ) {
            HStack {
                Text("A")
                Spacer()
                Text("B")
            }
        }
    }
    
    func testDivider() throws {
        try assertMatch(
            #"""
            <v-stack>
                <text>A</text>
                <divider />
                <text>B</text>
            </v-stack>
            """#
        ) {
            VStack {
                Text("A")
                Divider()
                Text("B")
            }
        }
    }
}
