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
    <Menu:label>
        <Text>Open Menu</Text>
    </Menu:label>
    <Menu:content>
        <Text>Menu Content</Text>
    </Menu:content>
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
    <Text>Open Menu</Text>
    <Menu:content>
        <Text>Menu Content</Text>
    </Menu:content>
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
    <Menu:label>
        <Text>Open Menu</Text>
    </Menu:label>
    <Menu:content>
        <Text>Menu Content</Text>
    </Menu:content>
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
