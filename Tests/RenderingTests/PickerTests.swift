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
            #"<ColorPicker>Foreground</ColorPicker>"#,
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
            <ColorPicker>
                Background
            </ColorPicker>
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
            <Picker value="paperplane" modifiers='[{"type": "picker_style", "style": "automatic"}]'>
                <Text template="label">Pick an icon</Text>
                <Group template="content">
                    <Label system-image="paperplane" modifiers='[{"type": "tag", "value": "paperplane"}]'><Text>paperplane</Text></Label>
                    <Label system-image="graduationcap" modifiers='[{"type": "tag", "value": "graduationcap"}]'><Text>graduationcap</Text></Label>
                    <Label system-image="ellipsis.bubble" modifiers='[{"type": "tag", "value": "ellipsis.bubble"}]'><Text>ellipsis.bubble</Text></Label>
                </Group>
            </Picker>
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
            <Picker value="paperplane" modifiers='[{"type": "picker_style", "style": "inline"}]'>
                <Text template="label">Pick an icon</Text>
                <Group template="content">
                    <Label system-image="paperplane" modifiers='[{"type": "tag", "value": "paperplane"}]'><Text>paperplane</Text></Label>
                    <Label system-image="graduationcap" modifiers='[{"type": "tag", "value": "graduationcap"}]'><Text>graduationcap</Text></Label>
                    <Label system-image="ellipsis.bubble" modifiers='[{"type": "tag", "value": "ellipsis.bubble"}]'><Text>ellipsis.bubble</Text></Label>
                </Group>
            </Picker>
            """#) {
                Picker(selection: .constant("paperplane")) {
                    ForEach(["paperplane", "graduationcap", "ellipsis.bubble"], id: \.self) { name in
                        Label {
                            Text(name)
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
            <VStack>
                <DatePicker value="\#(date.formatted(.elixirDateTime))" modifiers='[{"type": "date_picker_style", "style": "compact"}]'>
                    <Text>Pick a date</Text>
                </DatePicker>
                <DatePicker value="\#(date.formatted(.elixirDateTime))" modifiers='[{"type": "date_picker_style", "style": "graphical"}]' />
                <DatePicker value="\#(date.formatted(.elixirDateTime))" displayed-components="date" modifiers='[{"type": "date_picker_style", "style": "wheel"}]' />
            </VStack>
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
            <MultiDatePicker start="2023-01-01" end="2023-01-31">
                <Text>Pick some dates</Text>
            </MultDatePicker>
            """#) {
                MultiDatePicker(selection: .constant([]), in: start..<end) {
                    Text("Pick some dates")
                }
            }
    }
#endif
}
