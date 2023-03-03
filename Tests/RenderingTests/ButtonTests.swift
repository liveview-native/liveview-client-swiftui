//
//  ButtonTests.swift
//  
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class ButtonTests: XCTestCase {
    func testButtonSimple() throws {
        try assertMatch(#"<button>Click Me</button>"#) {
            Button("Click Me") {}
        }
    }
    func testButtonComplexBody() throws {
        try assertMatch(
            #"""
            <button>
                <h-stack>
                    <image system-name="circle.fill" />
                    <text>Tap Here</text>
                </h-stack>
            </button>
            """#
        ) {
            Button(action: {}) {
                HStack {
                    Image(systemName: "circle.fill")
                    Text("Tap Here")
                }
            }
        }
    }
    func testButtonStyles() throws {
        try assertMatch(#"<button button-style="automatic">Click Me</button>"#) {
            Button("Click Me") {}
                .buttonStyle(.automatic)
        }
        try assertMatch(#"<button button-style="bordered">Click Me</button>"#) {
            Button("Click Me") {}
                .buttonStyle(.bordered)
        }
        try assertMatch(#"<button button-style="bordered-prominent">Click Me</button>"#) {
            Button("Click Me") {}
                .buttonStyle(.borderedProminent)
        }
        try assertMatch(#"<button button-style="borderless">Click Me</button>"#) {
            Button("Click Me") {}
                .buttonStyle(.borderless)
        }
        try assertMatch(#"<button button-style="plain">Click Me</button>"#) {
            Button("Click Me") {}
                .buttonStyle(.plain)
        }
    }

    func testRenameButton() throws {
        try assertMatch(#"<rename-button />"#) {
            RenameButton()
        }
        try assertMatch(#"<rename-button modifiers='[{"type":"rename_action","event":"rename","target":null}]' />"#) {
            RenameButton()
                .renameAction {}
        }
    }
}
