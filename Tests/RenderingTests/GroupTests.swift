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
            <GroupBox>
                <GroupBox:label>
                    Label
                </GroupBox:label>
                <GroupBox:content>
                    Content
                </GroupBox:content>
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
                <GroupBox:label>
                    Label
                </GroupBox:label>
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
                <ControlGroup:label>
                    Label
                </ControlGroup:label>
                <ControlGroup:content>
                    <Button>Action #1</Button>
                    <Button>Action #2</Button>
                    <Button>Action #3</Button>
                </ControlGroup:content>
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
    
    func testControlGroupStyles() throws {
        try assertMatch(
            #"""
            <ControlGroup control-group-style="automatic">
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
            .controlGroupStyle(.automatic)
        }
        try assertMatch(
            #"""
            <ControlGroup control-group-style="navigation">
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
            .controlGroupStyle(.navigation)
        }
    }
    
    // MARK: DisclosureGroup
    func testDisclosureGroup() throws {
        try assertMatch(
            #"""
            <DisclosureGroup>
                <DisclosureGroup:label>Expandable Section</DisclosureGroup:label>
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
                <DisclosureGroup:label>Expandable Section</DisclosureGroup:label>
                <DisclosureGroup:content>Content</DisclosureGroup:content>
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
