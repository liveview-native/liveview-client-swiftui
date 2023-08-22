//
//  DrawingAndGraphicsModifiersTests.swift
//  
//
//  Created by Carson Katri on 5/3/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

/// Some graphics view modifiers don't render properly in `assertMatch`. If you expect a test to fail and it doesn't, then you might need to pass `useDrawingGroup: true`. See `testBrightness` for an example.
///
/// https://developer.apple.com/documentation/swiftui/view/drawinggroup(opaque:colormode:)

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
    
    func testClipShape() throws {
        try assertMatch(
            #"""
            <Text modifiers='[{"shape":{"key":null,"properties":{},"static":"circle"},"style":null,"type":"clip_shape"}]'>
            Hello,
            world!
            </Text>
            """#
        ) {
            Text("Hello,\nworld!")
                .clipShape(Circle())
        }
        
        try assertMatch(
            #"""
            <Text modifiers='[{"shape":{"key":null,"properties":{"radius":10},"static":"rounded_rectangle"},"style":null,"type":"clip_shape"}]'>
                Hello, world!
            </Text>
            """#
        ) {
            Text("Hello, world!")
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        
        try assertMatch(
            #"""
            <Text modifiers='[{"shape":{"key":"my_shape","properties":{},"static":null},"style":null,"type":"clip_shape"}]'>
                Hello, world!
                <Rectangle template="my_shape" modifiers='[{"anchor":null,"angle":0.7853981633974483,"type":"rotation"}]' />
            </Text>
            """#
        ) {
            Text("Hello, world!")
                .clipShape(Rectangle().rotation(.degrees(45)))
        }
    }
    
    func testTransformEffect() throws {
        try assertMatch(
            #"""
            <Text modifiers='[{"transform":[1,0,0,1,10,-10],"type":"transform_effect"}]'>
                Hello, world!
            </Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text("Hello, world!")
                .transformEffect(.init(translationX: 10, y: -10))
        }
        try assertMatch(
            #"""
            <Text modifiers='[{"transform":[0.7071067811865476,0.7071067811865475,-0.7071067811865475,0.7071067811865476,10,-10],"type":"transform_effect"}]'>
                Hello, world!
            </Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text("Hello, world!")
                .transformEffect(.init(translationX: 10, y: -10).rotated(by: 45 * (.pi / 180)))
        }
        try assertMatch(
            #"""
            <Text modifiers='[{"transform":[0.7071067811865476,0.7071067811865475,-0.7071067811865475,0.7071067811865476,14.142135623730951,-8.881784197001252e-16],"type":"transform_effect"}]'>
                Hello, world!
            </Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text("Hello, world!")
                .transformEffect(
                    .init(rotationAngle: 45 * (.pi / 180))
                        .translatedBy(x: 10, y: -10)
                )
        }
        try assertMatch(
            #"""
            <Text modifiers='[{"transform":[0.3535533905932738,0.35355339059327373,-0.7071067811865475,0.7071067811865476,14.142135623730951,-8.881784197001252e-16],"type":"transform_effect"}]'>
                Hello, world!
            </Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text("Hello, world!")
                .transformEffect(
                    .init(rotationAngle: 45 * (.pi / 180))
                        .translatedBy(x: 10, y: -10)
                        .scaledBy(x: 0.5, y: 1)
                )
        }
    }
    
    func testBrightness() throws {
        try assertMatch(
            #"""
            <Color name="system-red" modifiers='[{"amount":0.5,"type":"brightness"}]' />
            """#,
            useDrawingGroup: true
        ) {
            Color.red
                .brightness(0.5)
        }
        
        try assertFail(
            #"""
            <Color name="system-red" modifiers='[{"amount":0.5,"type":"brightness"}]' />
            """#,
            useDrawingGroup: true
        ) {
            Color.red
                .brightness(0.1)
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
                """#
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

    func testClipped() throws {
        for antialiased in [true, false] {
            try assertMatch(
            #"""
            <Circle modifiers='[{"color":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-mint","white":null},"type":"foreground_color"},{"alignment":"center","height":120.0,"type":"frame","width":120.0},{"antialiased":\#(antialiased),"type":"clipped"}]' />
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
            useDrawingGroup: true
        ) {
            Color.red
                .colorInvert()
        }
        
        try assertFail(
            #"""
            <Color name="system-red" modifiers='[{"type":"color_invert"}]' />
            """#,
            useDrawingGroup: true
        ) {
            Color.red
        }
    }
    
    func testColorMultiply() throws {
        try assertMatch(
            #"""
            <Color name="system-red" modifiers='[{"color":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-mint","white":null},"type":"color_multiply"}]' />
            """#,
            size: .init(width: 100, height: 100),
            useDrawingGroup: true
        ) {
            Color.red
                .colorMultiply(.mint)
        }
        
        try assertFail(
            #"""
            <Color name="system-red" modifiers='[{"color":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-mint","white":null},"type":"color_multiply"}]' />
            """#,
            useDrawingGroup: true
        ) {
            Color.red
                .colorMultiply(.blue)
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
            """#
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
                <Color name='system-red' modifiers='[{"amount":\#(amount),"type":"contrast"}]' />
                """#,
                useDrawingGroup: true
            ) {
                Color.red
                    .contrast(amount)
            }
            
            try assertFail(
                #"""
                <Color name='system-red' modifiers='[{"amount":\#(amount),"type":"contrast"}]' />
                """#,
                useDrawingGroup: true
            ) {
                Color.red
                    .contrast(0.1)
            }
        }
    }
    
    func testCornerRadius() throws {
        for antialiased in [true, false] {
            try assertMatch(
                #"""
                <Image system-name="square.fill" modifiers='[{"antialiased":\#(antialiased),"radius":8.0,"type":"corner_radius"}]' />
                """#,
                size: .init(width: 100, height: 100),
                useDrawingGroup: true
            ) {
                Image(systemName: "square.fill")
                    .cornerRadius(8.0, antialiased: antialiased)
                
            }
            
            try assertFail(
                #"""
                <Image system-name="square.fill" modifiers='[{"antialiased":\#(antialiased),"radius":8.0,"type":"corner_radius"}]' />
                """#,
                size: .init(width: 100, height: 100),
                useDrawingGroup: true
            ) {
                Image(systemName: "square.fill")
                    .cornerRadius(8.0, antialiased: !antialiased)
                
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
    
    func testGrayscale() throws {
        try assertMatch(
            #"""
            <Color name='system-red' modifiers='[{"amount":0.5,"type":"grayscale"}]' />
            """#,
            useDrawingGroup: true
        ) {
            Color.red
                .grayscale(0.5)
        }
        
        try assertFail(
            #"""
            <Color name='system-red' modifiers='[{"amount":0.5,"type":"grayscale"}]' />
            """#,
            useDrawingGroup: true
        ) {
            Color.red
                .grayscale(0.2)
        }
    }
    
    func testLuminanceToAlpha() throws {
        try assertMatch(
            #"""
            <Color name='system-red' modifiers='[{"type":"luminance_to_alpha"}]' />
            """#,
            useDrawingGroup: true
        ) {
            Color.red
                .luminanceToAlpha()
        }
        
        try assertFail(
            #"""
            <Color name='system-red' modifiers='[{"type":"luminance_to_alpha"}]' />
            """#,
            useDrawingGroup: true
        ) {
            Color.red
        }
    }
    
    func testMask() throws {
        try assertMatch(
            #"""
            <Image
                system-name="envelope.badge.fill"
                modifiers='[{"color":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-blue","white":null},"type":"foreground_color"},{"font":{"modifiers":[],"properties":{"style":"large_title"},"type":"system"},"type":"font"},{"alignment":"center","mask":"mask","type":"mask"}]'
            >
                <Rectangle template="mask" modifiers='[{"opacity":0.1,"type":"opacity"}]' />
            </Image>
            """#,
            useDrawingGroup: true
        ) {
            Image(systemName: "envelope.badge.fill")
                .foregroundColor(.blue)
                .font(.largeTitle)
                .mask(alignment: .center) {
                    Rectangle()
                        .opacity(0.1)
                }
        }
    }
    
    func testSaturation() throws {
        try assertMatch(
            #"""
            <Color name='system-red' modifiers='[{"amount":0.5,"type":"saturation"}]' />
            """#,
            useDrawingGroup: true
        ) {
            Color.red
                .saturation(0.5)
        }
        
        try assertFail(
            #"""
            <Color name='system-red' modifiers='[{"amount":0.5,"type":"saturation"}]' />
            """#,
            useDrawingGroup: true
        ) {
            Color.red
                .saturation(0.2)
        }
    }
    
    func testScaledToFill() throws {
        try assertMatch(
            #"""
            <Circle modifiers='[{"color":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-red","white":null},"type":"foreground_color"},{"type":"scaled_to_fill"},{"alignment":"center","height":20.0,"type":"frame","width":50.0}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Circle()
                .foregroundColor(.red)
                .scaledToFill()
                .frame(width: 50, height: 20)
        }
    }
    
    func testScaledToFit() throws {
        try assertMatch(
            #"""
            <Circle modifiers='[{"color":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-red","white":null},"type":"foreground_color"},{"type":"scaled_to_fit"},{"alignment":"center","height":20.0,"type":"frame","width":50.0}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Circle()
                .foregroundColor(.red)
                .scaledToFit()
                .frame(width: 50, height: 20)
        }
    }
    
    func testScaleEffect() throws {
        try assertMatch(
            #"""
            <Circle modifiers='[{"color":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-red","white":null},"type":"foreground_color"},{"anchor":{"named":"bottom","x":null,"y":null},"scale":[0.5,0.5],"type":"scale_effect"}]' />
            """#
        ) {
            Circle()
                .foregroundColor(.red)
                .scaleEffect(x: 0.5, y: 0.5, anchor: .bottom)
        }
    }
    
    func testShadow() throws {
        try assertMatch(
            #"""
            <Text modifiers='[{"color":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-gray","white":null},"radius":2.0,"type":"shadow","x":2.0,"y":2.0}]'>Hello</Text>
            """#
        ) {
            Text("Hello")
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
        }
    }
    
    func testProjectionEffect() throws {
        #if !os(watchOS)
        try assertMatch(
            #"""
            <Text modifiers='[{"transform":[-0.5,6.123233995736766e-17,0.0,0.0,-6.123233995736766e-17,-0.5,0.0,0.0,0.0,0.0,0.5,0.0,0.0,1.0,1.0,1.0],"type":"projection_effect"}]'>Hello</Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text("Hello")
                .projectionEffect(.init(
                    CATransform3DScale(
                        CATransform3DRotate(
                            CATransform3DMakeTranslation(0, 1, 1),
                            .pi, 0, 0, 1
                        ),
                        0.5, 0.5, 0.5
                    )
                ))
        }
        #endif
    }
    
    func testSymbolVariant() throws {
        let variantNames = [
            ["none"],
            ["circle"],
            ["square"],
            ["rectangle"],
            ["fill"],
            ["slash"],
            ["circle", "fill"]
        ]
        let variants: [SymbolVariants] = try .init(jsonValues: variantNames)
        let encode: ([String]) throws -> String = { String(data: try JSONEncoder().encode($0), encoding: .utf8)! }
        
        for (index, variant) in variants.enumerated() {
            try assertMatch(
                #"""
                <Image system-name="envelope.badge" modifiers='[{"type":"symbol_variant","variant":\#(try encode(variantNames[index]))}]' />
                """#
            ) {
                Image(systemName: "envelope.badge")
                    .symbolVariant(variant)
            }
        }
    }
}
