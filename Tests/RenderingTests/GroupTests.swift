//
//  GroupTests.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class GroupTests: XCTestCase {
#if os(iOS) || os(macOS)
    // MARK: GroupBox
    func testGroupBox() throws {
        try assertMatch(
            #"""
            <group-box>
                <group-box:label>
                    Label
                </group-box:label>
                <group-box:content>
                    Content
                </group-box:content>
            </group-box>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            GroupBox {
                Text("Content")
            } label: {
                Text("Label")
            }
        }
    }
    
    func testGroupBoxDefaultSlot() throws {
        try assertMatch(
            #"""
            <group-box>
                <group-box:label>
                    Label
                </group-box:label>
                Content
            </group-box>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            GroupBox {
                Text("Content")
            } label: {
                Text("Label")
            }
        }
    }
    
    func testGroupBoxTitle() throws {
        try assertMatch(
            #"""
            <group-box title="Label">
                Content
            </group-box>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            GroupBox("Label") {
                Text("Content")
            }
        }
    }
    
    // MARK: ControlGroup
    
    func testControlGroup() throws {
        try assertMatch(
            #"""
            <control-group>
                <button>Action #1</button>
                <button>Action #2</button>
                <button>Action #3</button>
            </control-group>
            """#
        ) {
            ControlGroup {
                Button("Action #1") {}
                Button("Action #2") {}
                Button("Action #3") {}
            }
        }
    }
    
    func testControlGroupSlots() throws {
        try assertMatch(
            #"""
            <control-group>
                <control-group:label>
                    Label
                </control-group:label>
                <control-group:content>
                    <button>Action #1</button>
                    <button>Action #2</button>
                    <button>Action #3</button>
                </control-group:content>
            </control-group>
            """#
        ) {
            ControlGroup {
                Button("Action #1") {}
                Button("Action #2") {}
                Button("Action #3") {}
            } label: {
                Text("Label")
            }
        }
    }
    
    func testControlGroupStyles() throws {
        try assertMatch(
            #"""
            <control-group control-group-style="automatic">
                <button>Action #1</button>
                <button>Action #2</button>
                <button>Action #3</button>
            </control-group>
            """#,
            lifetime: .keepAlways
        ) {
            ControlGroup {
                Button("Action #1") {}
                Button("Action #2") {}
                Button("Action #3") {}
            }
            .controlGroupStyle(.automatic)
        }
        try assertMatch(
            #"""
            <control-group control-group-style="navigation">
                <button>Action #1</button>
                <button>Action #2</button>
                <button>Action #3</button>
            </control-group>
            """#,
            lifetime: .keepAlways
        ) {
            ControlGroup {
                Button("Action #1") {}
                Button("Action #2") {}
                Button("Action #3") {}
            }
            .controlGroupStyle(.navigation)
        }
    }
#endif
}
