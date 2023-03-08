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
    
#if os(iOS)
    func testDatePicker() throws {
        let date = DateComponents(calendar: .current, year: 2023, month: 1, day: 1, hour: 8, minute: 30, second: 42).date!
        try assertMatch(
            #"""
            <vstack>
                <date-picker value="\#(date.formatted(.elixirDateTime))" date-picker-style="compact">
                    <text>Pick a date</text>
                </date-picker>
                <date-picker value="\#(date.formatted(.elixirDateTime))" date-picker-style="graphical" />
                <date-picker value="\#(date.formatted(.elixirDateTime))" date-picker-style="wheel" displayed-components="date" />
            </vstack>
            """#) {
                VStack {
                    DatePicker(selection: .constant(date), displayedComponents: [.date, .hourAndMinute]) {
                        Text("Pick a date")
                    }
                    .datePickerStyle(.compact)
                    DatePicker(selection: .constant(date), displayedComponents: [.date, .hourAndMinute]) {
                    }
                    .datePickerStyle(.graphical)
                    DatePicker(selection: .constant(date), displayedComponents: .date) {
                    }
                    .datePickerStyle(.wheel)
                }
        }
    }
    
    func testMultiDatePicker() throws {
        let start = DateComponents(calendar: .current, year: 2023, month: 1, day: 1).date!
        let end = DateComponents(calendar: .current, year: 2023, month: 1, day: 31).date!
        try assertMatch(
            #"""
            <multi-date-picker start="2023-01-01" end="2023-01-31">
                <text>Pick some dates</text>
            </mult-date-picker>
            """#) {
                MultiDatePicker(selection: .constant([]), in: start..<end) {
                    Text("Pick some dates")
                }
            }
    }
#endif
}
