//
//  ShapeModifiersTests.swift
//
//
//  Created by Carson Katri on 5/11/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class ShapeModifiersTests: XCTestCase {
    func testFill() throws {
        try assertMatch(
            #"""
            <Circle modifiers='[{"content":{"concrete_style":"color","modifiers":[],"style":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-red","white":null}},"style":null,"type":"fill"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Circle()
                .fill(.red)
        }
    }
    
    func testInset() throws {
        try assertMatch(
            #"""
            <Circle modifiers='[{"amount":25.0,"type":"inset"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Circle()
                .inset(by: 25)
        }
    }
    
    func testOffset() throws {
        try assertMatch(
            #"""
            <Circle modifiers='[{"type":"offset_shape","x":10.0,"y":25.0}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Circle()
                .offset(x: 10, y: 25)
        }
    }
    
    func testRotation() throws {
        try assertMatch(
            #"""
            <Rectangle modifiers='[{"anchor":null,"angle":0.7853981633974483,"type":"rotation"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Rectangle()
                .rotation(.degrees(45))
        }
    }
    
    func testSize() throws {
        try assertMatch(
            #"""
            <Rectangle modifiers='[{"height":75.0,"type":"size","width":50.0}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Rectangle()
                .size(width: 50, height: 75)
        }
    }
    
    func testStroke() throws {
        try assertMatch(
            #"""
            <Circle modifiers='[{"content":{"concrete_style":"color","modifiers":[],"style":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-red","white":null}},"style":{"dash":[],"dash_phase":0,"line_cap":"butt","line_join":"miter","line_width":10,"miter_limit":10},"type":"stroke"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Circle()
                .stroke(.red, style: .init(lineWidth: 10))
        }
    }
    
    func testStrokeBorder() throws {
        try assertMatch(
            #"""
            <Circle modifiers='[{"antialiased":true,"content":{"concrete_style":"color","modifiers":[],"style":{"blue":null,"brightness":null,"green":null,"hue":null,"opacity":null,"red":null,"rgb_color_space":null,"saturation":null,"string":"system-red","white":null}},"style":{"dash":[],"dash_phase":0,"line_cap":"butt","line_join":"miter","line_width":10,"miter_limit":10},"type":"stroke_border"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Circle()
                .strokeBorder(.red, style: .init(lineWidth: 10))
        }
    }
    
    func testTrim() throws {
        try assertMatch(
            #"""
            <Circle modifiers='[{"end_fraction":1.0,"start_fraction":0.5,"type":"trim"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Circle()
                .trim(from: 0.5, to: 1)
        }
    }
    
    func testContainerShape() throws {
        try assertMatch(
            #"""
            <ContainerRelativeShape modifiers='[{"shape":{"key":null,"properties":{},"static":"circle"},"type":"container_shape"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            ContainerRelativeShape()
                .containerShape(Circle())
        }
        try assertMatch(
            #"""
            <ContainerRelativeShape modifiers='[{"shape":{"key":null,"properties":{},"static":"capsule"},"type":"container_shape"}]' />
            """#,
            size: .init(width: 200, height: 100)
        ) {
            ContainerRelativeShape()
                .containerShape(Capsule())
        }
    }
}
