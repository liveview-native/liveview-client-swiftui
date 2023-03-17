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
        try assertMatch(#"<Button>Click Me</Button>"#) {
            Button("Click Me") {}
        }
    }
    func testButtonComplexBody() throws {
        try assertMatch(
            #"""
            <Button>
                <HStack>
                    <Image system-name="circle.fill" />
                    <Text>Tap Here</Text>
                </HStack>
            </Button>
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
        try assertMatch(#"<Button button-style="automatic">Click Me</Button>"#) {
            Button("Click Me") {}
                .buttonStyle(.automatic)
        }
        try assertMatch(#"<Button button-style="bordered">Click Me</Button>"#) {
            Button("Click Me") {}
                .buttonStyle(.bordered)
        }
        try assertMatch(#"<Button button-style="bordered-prominent">Click Me</Button>"#) {
            Button("Click Me") {}
                .buttonStyle(.borderedProminent)
        }
        try assertMatch(#"<Button button-style="borderless">Click Me</Button>"#) {
            Button("Click Me") {}
                .buttonStyle(.borderless)
        }
        try assertMatch(#"<Button button-style="plain">Click Me</Button>"#) {
            Button("Click Me") {}
                .buttonStyle(.plain)
        }
    }

    func testRenameButton() throws {
        try assertMatch(#"<RenameButton />"#) {
            RenameButton()
        }
        try assertMatch(#"<RenameButton modifiers='[{"type":"rename_action","event":"rename","target":null}]' />"#) {
            RenameButton()
                .renameAction {}
        }
    }
}
