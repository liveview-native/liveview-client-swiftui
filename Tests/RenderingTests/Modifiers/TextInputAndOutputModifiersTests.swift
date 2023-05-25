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
    private let shortString = "Placeholder"
    private let longString = """
    A text view always uses exactly the amount of space it needs to display its rendered contents, but you can affect the view’s layout. For example, you can use the frame(width:height:alignment:) modifier to propose specific dimensions to the view. If the view accepts the proposal but the text doesn’t fit into the available space, the view uses a combination of wrapping, tightening, scaling, and truncation to make it fit. With a width of 100 points but no constraint on the height, a text view might wrap a long string:
    """
    
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

    func testPrivacySensitive() throws {
        try assertMatch(
            #"""
            <Text modifiers="[{&quot;sensitive&quot;:true,&quot;type&quot;:&quot;privacy_sensitive&quot;}]">Private Information</Text>
            """#
        ) {
            Text("Private Information")
            .privacySensitive()
        
        }
        try assertMatch(
            #"""
            <Text modifiers="[{&quot;sensitive&quot;:false,&quot;type&quot;:&quot;privacy_sensitive&quot;}]">Private Information</Text>
            """#
        ) {
            Text("Private Information")
            .privacySensitive(false)
        
        }
    }
    
    func testAutocorrectionDisabled() throws {
        /// This can test parsing and building, but not visual matching of the keyboard with the current test scaffolding
        for disable in [true, false] {
            try assertMatch(
                #"""
                <TextField modifiers='[{"disable":\#(disable),"type":"autocorrection_disabled"}]'>\#(shortString)</TextField>
                """#
            ) {
                TextField(shortString, text: .constant(""))
                    .autocorrectionDisabled(disable)
            }
        }
    }
    
    func testFlipsForRightToLeftLayoutDirection() throws {
        for enabled in [true, false] {
            try assertMatch(
                #"""
                <TextField modifiers='[{"enabled":\#(enabled),"type":"flips_for_right_to_left_layout_direction"}]'>\#(shortString)</TextField>
                """#,
                environment: {
                    $0.layoutDirection = .rightToLeft
                }
            ) {
                TextField(shortString, text: .constant(""))
                    .flipsForRightToLeftLayoutDirection(enabled)
            }
        }
    }
    
    func testKerning() throws {
        try assertMatch(
            #"""
            <Text modifiers='[{"kerning":0.2,"type":"kerning"}]'>Hello</Text>
            <Text modifiers='[{"kerning":0,"type":"kerning"}]'>Hello</Text>
            """#
        ) {
            Text("Hello")
                .kerning(0.2)
            Text("Hello")
        }
    }
        
    func testLineLimit() throws {
        try assertMatch(
            #"""
            <Text modifiers='[{"number":2,"type":"line_limit"}]'>\#(longString)</Text>
            <Text modifiers='[{"type":"line_limit"}]'>\#(longString)</Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text(longString)
                .lineLimit(2)
            Text(longString)
        }
    }
    
    func testLineSpacing() throws {
        try assertMatch(
            #"""
            <Text modifiers='[{"line_spacing":0.2,"type":"line_spacing"}]'>\#(longString)</Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text(longString)
                .lineSpacing(0.2)
        }
    }
    
    func testMinimumScaleFactor() throws {
        try assertMatch(
            #"""
            <Text modifiers='[{"factor":0.2,"type":"minimum_scale_factor"},{"number":1,"type":"line_limit"}]'>\#(longString)</Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text(longString)
                .minimumScaleFactor(0.2)
                .lineLimit(1)
        }
    }
    
    func testMultilineTextAlignment() throws {
        try assertMatch(
            #"""
            <Text modifiers='[{"alignment":"center","type":"multiline_text_alignment"}]'>\#(longString)</Text>
            <Text modifiers='[{"alignment":"leading","type":"multiline_text_alignment"}]'>\#(longString)</Text>
            <Text modifiers='[{"alignment":"trailing","type":"multiline_text_alignment"}]'>\#(longString)</Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text(longString)
                .multilineTextAlignment(.center)
            Text(longString)
                .multilineTextAlignment(.leading)
            Text(longString)
                .multilineTextAlignment(.trailing)
        }
    }
    
    func testTracking() throws {
        try assertMatch(
            #"""
            <Text modifiers='[{"tracking":0.2,"type":"tracking"}]'>\#(longString)</Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text(longString)
                .tracking(0.2)
        }
    }
    
    func testTruncationMode() throws {
        try assertMatch(
            #"""
            <Text modifiers='[{"mode":"head","type":"truncation_mode"}]'>\#(longString)</Text>
            <Text modifiers='[{"mode":"middle","type":"truncation_mode"}]'>\#(longString)</Text>
            <Text modifiers='[{"mode":"tail","type":"truncation_mode"}]'>\#(longString)</Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text(longString)
                .truncationMode(.head)
            Text(longString)
                .truncationMode(.middle)
            Text(longString)
                .truncationMode(.tail)
        }
    }
}
