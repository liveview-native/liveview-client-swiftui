//
//  StackTests.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class StackTests: XCTestCase {
    func testVStack() throws {
        try assertMatch(
            #"""
            <VStack>
                <Text>A</Text>
                <Text>B</Text>
                <Text>C</Text>
            </VStack>
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
            <HStack>
                <Text>A</Text>
                <Text>B</Text>
                <Text>C</Text>
            </HStack>
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
            <ZStack>
                <Text>A</Text>
                <Text>B</Text>
                <Text>C</Text>
            </ZStack>
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
