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
    func testRenameButton() throws {
        try assertMatch(#"<RenameButton />"#) {
            RenameButton()
        }
    }
}
