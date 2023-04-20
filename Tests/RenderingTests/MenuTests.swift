//
//  MenuTests.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class MenuTests: XCTestCase {
    #if !os(watchOS)
    func testSimple() throws {
        try assertMatch(#"""
<Menu>
    <Text template="label">
        Open Menu
    </Text>
    <Text template="content">
        Menu Content
    </Text>
</Menu>
"""#) {
            Menu {
                Text("Menu Content")
            } label: {
                Text("Open Menu")
            }
        }
    }
    
    func testDefaultSlot() throws {
        try assertMatch(#"""
<Menu>
    <Text template="label">Open Menu</Text>
    <Text>
        Menu Content
    </Text>
</Menu>
"""#) {
            Menu {
                Text("Menu Content")
            } label: {
                Text("Open Menu")
            }
        }
    }
    
    func testSlotPrecedence() throws {
        try assertMatch(#"""
<Menu>
    <Text>Default Slot</Text>
    <Text template="label">
        Open Menu
    </Text>
    <Text template="content">
        Menu Content
    </Text>
</Menu>
"""#) {
            Menu {
                Text("Menu Content")
            } label: {
                Text("Open Menu")
            }
        }
    }
    #endif
}
