//
//  ButtonTests.swift
//  
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
import LiveViewNative

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
        try assertMatch(#"<Button modifiers='[{"type": "button_style", "style": "automatic"}]'>Click Me</Button>"#) {
            Button("Click Me") {}
                .buttonStyle(.automatic)
        }
        try assertMatch(#"<Button modifiers='[{"type": "button_style", "style": "bordered"}]'>Click Me</Button>"#) {
            Button("Click Me") {}
                .buttonStyle(.bordered)
        }
        try assertMatch(#"<Button modifiers='[{"type": "button_style", "style": "bordered_prominent"}]'>Click Me</Button>"#) {
            Button("Click Me") {}
                .buttonStyle(.borderedProminent)
        }
        try assertMatch(#"<Button modifiers='[{"type": "button_style", "style": "borderless"}]'>Click Me</Button>"#) {
            Button("Click Me") {}
                .buttonStyle(.borderless)
        }
        try assertMatch(#"<Button modifiers='[{"type": "button_style", "style": "plain"}]'>Click Me</Button>"#) {
            Button("Click Me") {}
                .buttonStyle(.plain)
        }
    }

    func testRenameButton() throws {
        try assertMatch(#"<RenameButton />"#) {
            RenameButton()
        }
        try assertMatch(#"<RenameButton modifiers='[{"type":"rename_action","action":{ "event": "rename" }}]' />"#) {
            RenameButton()
                .renameAction {}
        }
    }
}
