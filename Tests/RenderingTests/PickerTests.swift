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
            <Picker value="paperplane">
                <Text template="label">Pick an icon</Text>
                <Group template="content">
                    <Label systemImage="paperplane" tag="paperplane"><Text>paperplane</Text></Label>
                    <Label systemImage="graduationcap" tag="graduationcap"><Text>graduationcap</Text></Label>
                    <Label systemImage="ellipsis.bubble" tag="ellipsis.bubble"><Text>ellipsis.bubble</Text></Label>
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
        }
    }
    
#if os(iOS)
    func testDatePicker() throws {
        let date = DateComponents(calendar: .current, year: 2023, month: 1, day: 1, hour: 8, minute: 30, second: 42).date!
        try assertMatch(
            #"""
            <VStack>
                <DatePicker selection="\#(date.formatted(.elixirDateTime))">
                    <Text>Pick a date</Text>
                </DatePicker>
            </VStack>
            """#) {
                VStack {
                    DatePicker(selection: .constant(date), displayedComponents: [.date, .hourAndMinute]) {
                        Text("Pick a date")
                    }
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
