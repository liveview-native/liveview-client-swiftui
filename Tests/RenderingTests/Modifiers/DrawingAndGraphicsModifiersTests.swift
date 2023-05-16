//
//  DrawingAndGraphicsModifiersTests.swift
//  
//
//  Created by Carson Katri on 5/3/23.
//

import XCTest
import SwiftUI
import LiveViewNative

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
}
