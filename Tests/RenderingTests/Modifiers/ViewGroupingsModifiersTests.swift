//
//  ViewGroupingsModifiersTests.swift
//
//
//  Created by Carson Katri on 5/4/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class ViewGroupingsModifiersTests: XCTestCase {
    func testControlGroupStyle() throws {
        #if os(iOS)
        try assertMatch(
            #"""
            <ControlGroup modifiers="[{&quot;style&quot;:&quot;automatic&quot;,&quot;type&quot;:&quot;control_group_style&quot;}]">
                <Button>Decrement</Button>
                <Button>Increment</Button>
            </ControlGroup>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            ControlGroup {
                Button("Decrement") {}
                Button("Increment") {}
            }
            .controlGroupStyle(.automatic)
        }
        try assertMatch(
            #"""
            <ControlGroup modifiers="[{&quot;style&quot;:&quot;navigation&quot;,&quot;type&quot;:&quot;control_group_style&quot;}]">
                <Button>Decrement</Button>
                <Button>Increment</Button>
            </ControlGroup>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            ControlGroup {
                Button("Decrement") {}
                Button("Increment") {}
            }
            .controlGroupStyle(.navigation)
        }
        #endif
    }
}
