//
//  DrawingAndGraphicsModifiersTests.swift
//  
//
//  Created by Carson Katri on 5/3/23.
//

import XCTest
import SwiftUI
import LiveViewNative

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
            size: .init(width: 100, height: 100),
            useDrawingGroup: true
        ) {
            Color.red
                .brightness(0.5)
        }
        
        try assertFail(
            #"""
            <Color name="system-red" modifiers='[{"amount":0.5,"type":"brightness"}]' />
            """#,
            size: .init(width: 100, height: 100),
            useDrawingGroup: true
        ) {
            Color.red
                .brightness(0.1)
        }
    }
}
