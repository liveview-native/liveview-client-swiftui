//
//  MenuTests.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class MenuTests: XCTestCase {
    #if !os(watchOS)
    func testSimple() throws {
        try assertMatch(#"""
<menu>
    <menu:label>
        <text>Open Menu</text>
    </menu:label>
    <menu:content>
        <text>Menu Content</text>
    </menu:content>
</menu>
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
<menu>
    <text>Open Menu</text>
    <menu:content>
        <text>Menu Content</text>
    </menu:content>
</menu>
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
<menu>
    <text>Default Slot</text>
    <menu:label>
        <text>Open Menu</text>
    </menu:label>
    <menu:content>
        <text>Menu Content</text>
    </menu:content>
</menu>
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
