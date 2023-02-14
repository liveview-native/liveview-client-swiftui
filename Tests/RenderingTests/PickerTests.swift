//
//  GroupTests.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class PickerTests: XCTestCase {
#if os(iOS) || os(macOS)
    // MARK: ColorPicker
    func testColorPicker() throws {
        try assertMatch(
            #"""
            <color-picker>
                <color-picker:label>Foreground</color-picker:label>
            </color-picker>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            ColorPicker(selection: .constant(.init(red: 0, green: 0, blue: 0, alpha: 1))) {
                Text("Foreground")
            }
        }
    }
    
    func testColorPickerDefaultSlot() throws {
        try assertMatch(
            #"""
            <color-picker>
                Background
            </color-picker>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            ColorPicker(selection: .constant(.init(red: 0, green: 0, blue: 0, alpha: 1))) {
                Text("Background")
            }
        }
    }
#endif
}
