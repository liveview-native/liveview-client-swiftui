//
//  ControlsAndIndicatorsModifiersTests.swift
//
//
//  Created by Shadowfacts on 5/5/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

#if os(iOS)
@MainActor
final class ControlsAndIndicatorsModifiersTests: XCTestCase {
    func testControlSize() throws {
        try assertMatch(
            #"""
            <VStack modifiers='[{"type": "button_style", "style": "bordered_prominent"}]'>
                <Button modifiers='[{"type": "control_size", "size": "mini"}]'>Mini</Button>
                <Button modifiers='[{"type": "control_size", "size": "small"}]'>Small</Button>
                <Button modifiers='[{"type": "control_size", "size": "regular"}]'>Regular</Button>
                <Button modifiers='[{"type": "control_size", "size": "large"}]'>Large</Button>
            </VStack>
            """#
        ) {
            VStack {
                Button("Mini") {}
                    .controlSize(.mini)
                Button("Small") {}
                    .controlSize(.small)
                Button("Regular") {}
                    .controlSize(.regular)
                Button("Large") {}
                    .controlSize(.large)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    func testButtonStyle() throws {
        try assertMatch(
            #"""
            <VStack>
                <Button modifiers='[{"type": "button_style", "style": "automatic"}]'>Automatic</Button>
                <Button modifiers='[{"type": "button_style", "style": "bordered"}]'>Bordered</Button>
                <Button modifiers='[{"type": "button_style", "style": "bordered_prominent"}]'>Bordered Prominent</Button>
                <Button modifiers='[{"type": "button_style", "style": "borderless"}]'>Borderless</Button>
                <Button modifiers='[{"type": "button_style", "style": "plain"}]'>Plain</Button>
            </VStack>
            """#
        ) {
            VStack {
                Button("Automatic") {}
                    .buttonStyle(.automatic)
                Button("Bordered") {}
                    .buttonStyle(.bordered)
                Button("Bordered Prominent") {}
                    .buttonStyle(.borderedProminent)
                Button("Borderless") {}
                    .buttonStyle(.borderless)
                Button("Plain") {}
                    .buttonStyle(.plain)
            }
        }
    }
    
    func testDatePickerStyle() throws {
        try assertMatch(
            #"""
            <VStack>
                <DatePicker value="2023-05-04" modifiers='[{"type": "date_picker_style", "style": "automatic"}]'>Automatic</DatePicker>
                <DatePicker value="2023-05-04" modifiers='[{"type": "date_picker_style", "style": "compact"}]'>Compact</DatePicker>
                <DatePicker value="2023-05-04" modifiers='[{"type": "date_picker_style", "style": "graphical"}]'>Graphical</DatePicker>
                <DatePicker value="2023-05-04" modifiers='[{"type": "date_picker_style", "style": "wheel"}]'>Wheel</DatePicker>
            </VStack>
            """#
        ) {
            SwiftUI.VStack {
                let date = Binding.constant(try! Date("2023-05-04", strategy: .elixirDate))
                SwiftUI.DatePicker(selection: date) {
                    Text("Automatic")
                }
                .datePickerStyle(.automatic)
                SwiftUI.DatePicker(selection: date) {
                    Text("Compact")
                }
                .datePickerStyle(.compact)
                SwiftUI.DatePicker(selection: date) {
                    Text("Graphical")
                }
                .datePickerStyle(.graphical)
                SwiftUI.DatePicker(selection: date) {
                    Text("Wheel")
                }
                .datePickerStyle(.wheel)
            }
        }
    }
    
    func testPickerStyle() throws {
        try assertMatch(
            #"""
            <VStack>
                <Picker value="a" modifiers='[{"type": "picker_style", "style": "automatic"}]'>
                    <Text template="label">Automatic</Text>
                    <Text template="content" modifiers='[{"type": "tag", "value": "a"}]'>a</Text>
                </Picker>
                <Picker value="a" modifiers='[{"type": "picker_style", "style": "inline"}]'>
                    <Text template="label">Inline</Text>
                    <Text template="content" modifiers='[{"type": "tag", "value": "a"}]'>a</Text>
                </Picker>
                <Picker value="a" modifiers='[{"type": "picker_style", "style": "menu"}]'>
                    <Text template="label">Menu</Text>
                    <Text template="content" modifiers='[{"type": "tag", "value": "a"}]'>a</Text>
                </Picker>
                <Picker value="a" modifiers='[{"type": "picker_style", "style": "navigation_link"}]'>
                    <Text template="label">Navigation Link</Text>
                    <Text template="content" modifiers='[{"type": "tag", "value": "a"}]'>a</Text>
                </Picker>
                <Picker value="a" modifiers='[{"type": "picker_style", "style": "segmented"}]'>
                    <Text template="label">Segmented</Text>
                    <Text template="content" modifiers='[{"type": "tag", "value": "a"}]'>a</Text>
                </Picker>
                <Picker value="a" modifiers='[{"type": "picker_style", "style": "wheel"}]'>
                    <Text template="label">Wheel</Text>
                    <Text template="content" modifiers='[{"type": "tag", "value": "a"}]'>a</Text>
                </Picker>
            </VStack>
            """#
        ) {
            VStack {
                Picker("Automatic", selection: .constant("a")) {
                    Text("a").tag("a")
                }
                .pickerStyle(.automatic)
                Picker("Inline", selection: .constant("a")) {
                    Text("a").tag("a")
                }
                .pickerStyle(.inline)
                Picker("Menu", selection: .constant("a")) {
                    Text("a").tag("a")
                }
                .pickerStyle(.menu)
                Picker("Navigation Link", selection: .constant("a")) {
                    Text("a").tag("a")
                }
                .pickerStyle(.navigationLink)
                Picker("Segmented", selection: .constant("a")) {
                    Text("a").tag("a")
                }
                .pickerStyle(.segmented)
                Picker("Wheel", selection: .constant("a")) {
                    Text("a").tag("a")
                }
                .pickerStyle(.wheel)
            }
        }
    }
    
    func testToggleStyle() throws {
        try assertMatch(
            #"""
            <VStack>
                <Toggle modifiers='[{"type": "toggle_style", "style": "automatic"}]'>Automatic</Toggle>
                <Toggle modifiers='[{"type": "toggle_style", "style": "button"}]'>Button</Toggle>
                <Toggle modifiers='[{"type": "toggle_style", "style": "switch"}]'>Switch</Toggle>
            </VStack>
            """#
        ) {
            VStack {
                Toggle("Automatic", isOn: .constant(false))
                    .toggleStyle(.automatic)
                Toggle("Button", isOn: .constant(false))
                    .toggleStyle(.button)
                Toggle("Switch", isOn: .constant(false))
                    .toggleStyle(.switch)
            }
        }
    }
    
    func testGaugeStyle() throws {
        try assertMatch(
            #"""
            <VStack>
                <Gauge value="0.5" modifiers='[{"type": "gauge_style", "style": "accessory_circular_capacity"}]'>Accessory Circular Capacity</Gauage>
                <Gauge value="0.5" modifiers='[{"type": "gauge_style", "style": "accessory_linear_capacity"}]'>Accessory Linear Capacity</Gauage>
                <Gauge value="0.5" modifiers='[{"type": "gauge_style", "style": "accessory_circular"}]'>Accessory Circular</Gauage>
                <Gauge value="0.5" modifiers='[{"type": "gauge_style", "style": "linear_capacity"}]'>Linear Capacity</Gauage>
                <Gauge value="0.5" modifiers='[{"type": "gauge_style", "style": "accessory_linear"}]'>Accessory Linear</Gauage>
            </VStack>
            """#,
            useDrawingGroup: false
        ) {
            VStack {
                Gauge(value: 0.5) {
                    Text("Accessory Circular Capacity")
                }
                .gaugeStyle(.accessoryCircularCapacity)
                Gauge(value: 0.5) {
                    Text("Accessory Linear Capacity")
                }
                .gaugeStyle(.accessoryLinearCapacity)
                Gauge(value: 0.5) {
                    Text("Accessory Circular")
                }
                .gaugeStyle(.accessoryCircular)
                Gauge(value: 0.5) {
                    Text("Linear Capacity")
                }
                .gaugeStyle(.linearCapacity)
                Gauge(value: 0.5) {
                    Text("Accessory Linear")
                }
                .gaugeStyle(.accessoryLinear)
            }
        }
    }
    
    func testProgressViewStyle() throws {
        try assertMatch(
            #"""
            <VStack>
                <ProgressView modifiers='[{"type": "progress_view_style", "style": "automatic"}]' />
                <ProgressView modifiers='[{"type": "progress_view_style", "style": "linear"}]' />
                <ProgressView modifiers='[{"type": "progress_view_style", "style": "circular"}]' />
            </VStack>
            """#
        ) {
            VStack {
                ProgressView()
                    .progressViewStyle(.automatic)
                ProgressView()
                    .progressViewStyle(.linear)
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
    
    func testButtonBorderShape() throws {
        try assertMatch(
            #"""
            <VStack modifiers='[{"type": "button_style", "style": "bordered"}]'>
                <Button modifiers='[{"type": "button_border_shape", "shape": "automatic"}]'>Automatic</Button>
                <Button modifiers='[{"type": "button_border_shape", "shape": "capsule"}]'>Capsule</Button>
                <Button modifiers='[{"type": "button_border_shape", "shape": "rounded_rectangle"}]'>Rounded Rectangle</Button>
                <Button modifiers='[{"type": "button_border_shape", "shape": "rounded_rectangle", "radius": 3}]'>Rounded Rectangle radius</Button>
            </VStack>
            """#
        ) {
            VStack {
                Button("Automatic") {}
                    .buttonBorderShape(.automatic)
                Button("Capsule") {}
                    .buttonBorderShape(.capsule)
                Button("Rounded Rectangle") {}
                    .buttonBorderShape(.roundedRectangle)
                Button("Rounded Rectangle radius") {}
                    .buttonBorderShape(.roundedRectangle(radius: 3))
            }
            .buttonStyle(.bordered)
        }
    }
}
#endif
