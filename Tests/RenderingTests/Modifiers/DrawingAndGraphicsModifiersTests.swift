//
//  DrawingAndGraphicsModifiersTests.swift
//  
//
//  Created by Carson Katri on 5/3/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class DrawingAndGraphicsModifiersTests: XCTestCase {
    func testRotationEffect() throws {
        try assertMatch(
            #"""
            <Rectangle fill-color="system-red" modifiers="[{&quot;anchor&quot;:null,&quot;angle&quot;:0.7853981633974483,&quot;type&quot;:&quot;rotation_effect&quot;}]" />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Rectangle()
                .fill(.red)
                .rotationEffect(.degrees(45))
        }
    }
    
    func testTint() throws {
        try assertMatch(
            #"""
            <Button modifiers='[{"type": "tint", "color": {"string": "system-red"}}]'>Hello</Button>
            """#
        ) {
            Button("Hello") {}
                .tint(.red)
        }
    }

    func testBlendMode() throws {
        let modeNames = [
            "normal",
            "darken",
            "multiply",
            "color_burn",
            "plus_darker",
            "lighten",
            "screen",
            "color_dodge",
            "plus_lighter",
            "overlay",
            "soft_light",
            "hard_light",
            "difference",
            "exclusion",
            "hue",
            "saturation",
            "color",
            "luminosity",
            "source_atop",
            "destination_over",
            "destination_out"
        ]
        let modes: [BlendMode] = try .init(jsonValues: modeNames)
        
        for (index, mode) in modes.enumerated() {
            try assertMatch(
                #"""
                <ZStack>
                    <Color name="system-red" />
                    <Color name="system-green" modifiers='[{"anchor":null,"angle":0.75,"type":"rotation_effect"},{"blend_mode":"\#(modeNames[index])","type":"blend_mode"}]' />
                </ZStack>
                """#,
                size: .init(width: 100, height: 100)
            ) {
                ZStack {
                    Color.red
                    Color.green
                        .rotationEffect(.radians(0.75))
                        .blendMode(mode)
                }
            }
        }
    }
    
    func testBrightness() throws {
        try assertMatch(
            #"""
            <Color name="system-red" modifiers='[{"amount":0.5,"type":"brightness"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Color.red
                .brightness(0.5)
        }
    }
    
    func testClipped() throws {
        for antialiased in [true, false] {
            try assertMatch(
            #"""
            <Circle modifiers='[{"color":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-mint","white":null},"type":"foreground_color"},{"alignment":null,"height":120.0,"type":"frame","width":120.0},{"antialiased":\#(antialiased),"type":"clipped"}]' />
            """#,
            size: .init(width: 100, height: 100)
            ) {
                Circle()
                    .foregroundColor(.mint)
                    .frame(width: 120, height: 120)
                    .clipped(antialiased: antialiased)
            }
        }
    }
    
    func testColorInvert() throws {
        try assertMatch(
            #"""
            <Color name="system-red" modifiers='[{"type":"color_invert"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Color.red
                .colorInvert()
        }
    }
    
    func testColorMultiply() throws {
        try assertMatch(
            #"""
            <Color name="system-red" modifiers='[{"color":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-mint","white":null},"type":"color_multiply"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Color.red
                .colorMultiply(.mint)
        }
    }
    
    func testCompositingGroup() throws {
        try assertMatch(
            #"""
            <HStack>
                <ZStack modifiers='[{"type":"compositing_group"},{"opacity":0.5,"type":"opacity"}]'>
                    <Text>Hello</Text>
                    <Text modifiers='[{"opaque":false,"radius":2.0,"type":"blur"}]'>Hello</Text>
                </ZStack>
            </HStack>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            HStack {
                ZStack {
                    Text("Hello")
                    Text("Hello")
                        .blur(radius: 2.0, opaque: false)
                }
                .compositingGroup()
                .opacity(0.5)
            }
        }
    }
    
    func testContrast() throws {
        for amount in [0.5, -0.5] {
            try assertMatch(
            #"""
            <Color name='system-red' modifiers='[{"amount":\#(amount),"type":"contrast"},{"color_mode":"non_linear","opaque":false,"type":"drawing_group"}]' />
            """#,
            size: .init(width: 100, height: 100)
            ) {
                Color.red
                    .contrast(amount)
                    .drawingGroup()
            }
        }
    }
    
    func testCornerRadius() throws {
        for antialiased in [true, false] {
            try assertMatch(
            #"""
            <Image system-name="square.fill" modifiers='[{"antialiased":\#(antialiased),"radius":8.0,"type":"corner_radius"}]' />
            """#,
            size: .init(width: 100, height: 100)
            ) {
                Image(systemName: "square.fill")
                    .cornerRadius(8.0, antialiased: antialiased)
                
            }
        }
    }
    
    func testDrawingGroup() throws {
        let modeNames = [
            "extended_linear",
            "linear",
            "non_linear",
        ]
        let colorRenderingModes: [ColorRenderingMode] = try .init(jsonValues: modeNames)
        
        for (index, mode) in colorRenderingModes.enumerated() {
            try assertMatch(
            #"""
            <HStack modifiers='[{"color_mode":"\#(modeNames[index])","opaque":false,"type":"drawing_group"}]'>
                <ZStack modifiers='[{"opacity":0.5,"type":"opacity"}]'>
                    <Text>Hello</Text>
                    <Text modifiers='[{"opaque":false,"radius":2.0,"type":"blur"}]'>Hello</Text>
                </ZStack>
            </HStack>
            """#,
            size: .init(width: 100, height: 100)
            ) {
                HStack {
                    ZStack {
                        Text("Hello")
                        Text("Hello")
                            .blur(radius: 2.0, opaque: false)
                    }
                    .opacity(0.5)
                }
                .drawingGroup(opaque: false, colorMode: mode)
            }
        }
    }
}
