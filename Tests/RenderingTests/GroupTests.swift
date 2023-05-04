//
//  GroupTests.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class GroupTests: XCTestCase {
#if os(iOS) || os(macOS)
    // MARK: GroupBox
    func testGroupBox() throws {
        try assertMatch(
            #"""
            <GroupBox>
                <Text template="label">
                    Label
                </Text>
                <Text template="content">
                    Content
                </Text>
            </GroupBox>
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
            <GroupBox>
                <Text template="label">
                    Label
                </Text>
                Content
            </GroupBox>
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
            <GroupBox title="Label">
                Content
            </GroupBox>
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
            <ControlGroup>
                <Button>Action #1</Button>
                <Button>Action #2</Button>
                <Button>Action #3</Button>
            </ControlGroup>
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
            <ControlGroup>
                <Text template="label">
                    Label
                </Text>
                <Group template="content">
                    <Button>Action #1</Button>
                    <Button>Action #2</Button>
                    <Button>Action #3</Button>
                </Group>
            </ControlGroup>
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
    
    // MARK: DisclosureGroup
    func testDisclosureGroup() throws {
        try assertMatch(
            #"""
            <DisclosureGroup>
                <Text template="label">Expandable Section</Text>
                Content
            </DisclosureGroup>
            """#
        ) {
            DisclosureGroup {
                Text("Content")
            } label: {
                Text("Expandable Section")
            }
        }
    }
    
    func testDisclosureGroupSlots() throws {
        try assertMatch(
            #"""
            <DisclosureGroup>
                <Text template="label">Expandable Section</Text>
                <Text template="content">Content</Text>
            </DisclosureGroup>
            """#
        ) {
            DisclosureGroup {
                Text("Content")
            } label: {
                Text("Expandable Section")
            }
        }
    }
#endif
}
