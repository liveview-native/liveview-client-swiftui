//
//  MenusAndCommandsModifiersTests.swift
//
//
//  Created by Shadowfacts on 5/12/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class MenusAndCommandsModifiersTests: XCTestCase {
    #if !os(watchOS) && !os(tvOS)
    func testMenuStyle() throws {
        try assertMatch(
            #"""
            <Menu modifiers='[{"type": "menu_style", "style": "button"}, {"type": "button_style", "style": "bordered_prominent"}]'>
                <Text template="label">
                    Edit Actions
                </Text>
                <Group template="content">
                    <Button>Arrange</Button>
                    <Button>Update</Button>
                    <Button>Remove</Button>
                </Group>
            </Menu>
            """#,
            size: .init(width: 200, height: 300)
        ) {
            Menu {
                Button("Arrange") {}
                Button("Update") {}
                Button("Remove") {}
            } label: {
                Text("Edit Actions")
            }
            .menuStyle(.button)
            .buttonStyle(.borderedProminent)
        }
    }
    #endif
}
