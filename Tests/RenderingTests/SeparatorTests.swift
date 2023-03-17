//
//  SeparatorTests.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class SeparatorTests: XCTestCase {
    func testSpacer() throws {
        try assertMatch(
            #"""
            <HStack>
                <Text>A</Text>
                <Spacer />
                <Text>B</Text>
            </HStack>
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
            <VStack>
                <Text>A</Text>
                <Divider />
                <Text>B</Text>
            </VStack>
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
