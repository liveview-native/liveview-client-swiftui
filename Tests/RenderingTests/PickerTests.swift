//
//  PickerTests.swift
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
    
    func testPicker() throws {
        try assertMatch(
            #"""
            <picker value="paperplane" picker-style="automatic">
                <picker:label><text>Pick an icon</text></picker:label>
                <picker:content>
                    <label system-image="paperplane" modifiers='[{"type": "tag", "value": "paperplane"}]'><text>paperplane</text></label>
                    <label system-image="graduationcap" modifiers='[{"type": "tag", "value": "graduationcap"}]'><text>graduationcap</text></label>
                    <label system-image="ellipsis.bubble" modifiers='[{"type": "tag", "value": "ellipsis.bubble"}]'><text>ellipsis.bubble</text></label>
                </picker:content>
            </picker>
            """#) {
                Picker(selection: .constant("paperplane")) {
                    ForEach(["paperplane", "graduationcap", "ellipsis.bubble"], id: \.self) { name in
                        Label {
                            Text(name)
                                // the Picker imposes a slightly different font by default, but our Text view uses nil, so match that
                                .font(nil)
                        } icon: {
                            Image(systemName: name)
                        }
                        .tag(name)
                    }
                } label: {
                    Text("Pick an icon")
                }
                .pickerStyle(.automatic)
        }
        
        try assertMatch(
            #"""
            <picker value="paperplane" picker-style="inline">
                <picker:label><text>Pick an icon</text></picker:label>
                <picker:content>
                    <label system-image="paperplane" modifiers='[{"type": "tag", "value": "paperplane"}]'><text>paperplane</text></label>
                    <label system-image="graduationcap" modifiers='[{"type": "tag", "value": "graduationcap"}]'><text>graduationcap</text></label>
                    <label system-image="ellipsis.bubble" modifiers='[{"type": "tag", "value": "ellipsis.bubble"}]'><text>ellipsis.bubble</text></label>
                </picker:content>
            </picker>
            """#) {
                Picker(selection: .constant("paperplane")) {
                    ForEach(["paperplane", "graduationcap", "ellipsis.bubble"], id: \.self) { name in
                        Label {
                            Text(name)
                                // the Picker imposes a slightly different font by default, but our Text view uses nil, so match that
                                .font(nil)
                        } icon: {
                            Image(systemName: name)
                        }
                        .tag(name)
                    }
                } label: {
                    Text("Pick an icon")
                }
                .pickerStyle(.inline)
        }
    }
}
