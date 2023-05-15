//
//  TextInputAndOutputModifiersTests.swift
//
//
//  Created by Carson Katri on 5/4/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class TextInputAndOutputModifiersTests: XCTestCase {
    func testBaselineOffset() throws {
        try assertMatch(
            #"""
            <HStack>
                <Text>
                    A
                </Text>
                <Text modifiers="[{&quot;offset&quot;:10.0,&quot;type&quot;:&quot;baseline_offset&quot;}]">
                    B
                </Text>
            </HStack>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            HStack {
                Text("A")
                Text("B")
                    .baselineOffset(10)
            }
        }
    }
    
    func testFont() throws {
        try assertMatch(
            #"""
            <Text modifiers="[{&quot;font&quot;:{&quot;modifiers&quot;:[],&quot;properties&quot;:{&quot;design&quot;:&quot;serif&quot;,&quot;style&quot;:&quot;large_title&quot;},&quot;type&quot;:&quot;system&quot;},&quot;type&quot;:&quot;font&quot;}]">
                Hello, world!
            </Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text("Hello, world!")
                .font(.system(.largeTitle, design: .serif))
        }
    }
    
    func testFontWidth() throws {
        try assertMatch(
            #"""
            <VStack>
                <Text modifiers="[{&quot;type&quot;:&quot;font_width&quot;,&quot;width&quot;:{&quot;name&quot;:&quot;compressed&quot;,&quot;value&quot;:null}}]">
                    Test
                </Text>
                <Text modifiers="[{&quot;type&quot;:&quot;font_width&quot;,&quot;width&quot;:{&quot;name&quot;:&quot;condensed&quot;,&quot;value&quot;:null}}]">
                    Test
                </Text>
                <Text modifiers="[{&quot;type&quot;:&quot;font_width&quot;,&quot;width&quot;:{&quot;name&quot;:&quot;standard&quot;,&quot;value&quot;:null}}]">
                    Test
                </Text>
                <Text modifiers="[{&quot;type&quot;:&quot;font_width&quot;,&quot;width&quot;:{&quot;name&quot;:&quot;expanded&quot;,&quot;value&quot;:null}}]">
                    Test
                </Text>
            </VStack>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            VStack {
                Text("Test")
                    .fontWidth(.compressed)
                Text("Test")
                    .fontWidth(.condensed)
                Text("Test")
                    .fontWidth(.standard)
                Text("Test")
                    .fontWidth(.expanded)
            }
        }
    }
    
    func testLabelStyle() throws {
        let content = #"""
        <Text template="title">Test</Text>
        <Image template="icon" system-name="circle" />
        """#
        let contentView = Label("Test", systemImage: "circle")
        try assertMatch(
            #"""
            <Label modifiers="[{&quot;style&quot;:&quot;icon_only&quot;,&quot;type&quot;:&quot;label_style&quot;}]">
                \#(content)
            </Label>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            contentView
                .labelStyle(.iconOnly)
        }
        try assertMatch(
            #"""
            <Label modifiers="[{&quot;style&quot;:&quot;title_only&quot;,&quot;type&quot;:&quot;label_style&quot;}]">
                \#(content)
            </Label>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            contentView
                .labelStyle(.titleOnly)
        }
        try assertMatch(
            #"""
            <Label modifiers="[{&quot;style&quot;:&quot;title_and_icon&quot;,&quot;type&quot;:&quot;label_style&quot;}]">
                \#(content)
            </Label>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            contentView
                .labelStyle(.titleAndIcon)
        }
        try assertMatch(
            #"""
            <Label modifiers="[{&quot;style&quot;:&quot;automatic&quot;,&quot;type&quot;:&quot;label_style&quot;}]">
                \#(content)
            </Label>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            contentView
                .labelStyle(.automatic)
        }
    }
    
    func testStrikethrough() throws {
        for enabled in [true, false] {
            try assertMatch(
                #"""
                <Text modifiers="[{&quot;color&quot;:{&quot;blue&quot;:null,&quot;brightness&quot;:null,&quot;green&quot;:null,&quot;hue&quot;:null,&quot;opacity&quot;:null,&quot;red&quot;:null,&quot;rgb_color_space&quot;:null,&quot;saturation&quot;:null,&quot;string&quot;:&quot;system-red&quot;,&quot;white&quot;:null},&quot;is_active&quot;:\#(enabled),&quot;pattern&quot;:&quot;dash_dot&quot;,&quot;type&quot;:&quot;strikethrough&quot;}]">
                    Hello, world!
                </Text>
                """#,
                size: .init(width: 100, height: 100)
            ) {
                Text("Hello, world!")
                    .strikethrough(enabled, pattern: .dashDot, color: .red)
            }
        }
    }
    
    func testTextFieldStyle() throws {
        #if os(iOS)
        try assertMatch(
            #"""
            <TextField modifiers="[{&quot;style&quot;:&quot;automatic&quot;,&quot;type&quot;:&quot;text_field_style&quot;}]">Placeholder</TextField>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            TextField("Placeholder", text: .constant(""))
                .textFieldStyle(.automatic)
        }
        try assertMatch(
            #"""
            <TextField modifiers="[{&quot;style&quot;:&quot;plain&quot;,&quot;type&quot;:&quot;text_field_style&quot;}]">Placeholder</TextField>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            TextField("Placeholder", text: .constant(""))
                .textFieldStyle(.plain)
        }
        try assertMatch(
            #"""
            <TextField modifiers="[{&quot;style&quot;:&quot;rounded_border&quot;,&quot;type&quot;:&quot;text_field_style&quot;}]">Placeholder</TextField>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            TextField("Placeholder", text: .constant(""))
                .textFieldStyle(.roundedBorder)
        }
        #endif
    }
    
    func testAutocorrectionDisabled() throws {
        for disable in [true, false] {
            try assertMatch(
                #"""
                <TextField modifiers='[{"disable":\#(disable),"type":"autocorrection_disabled"}]'>Enter text</TextField>
                """#
            ) {
                TextField("Enter text", text: .constant(""))
                    .autocorrectionDisabled(disable)
            }
        }
    }
}
