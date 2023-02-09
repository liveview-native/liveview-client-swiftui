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
    // MARK: GroupBox
    
#if os(iOS) || os(macOS)
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
#endif
}
