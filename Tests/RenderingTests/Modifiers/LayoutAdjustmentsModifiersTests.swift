//
//  LayoutAdjustmentsModifiersTests.swift
//
//
//  Created by Carson Katri on 5/4/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class LayoutAdjustmentsModifiersTests: XCTestCase {
    func testFixedSize() throws {
        try assertMatch(
            #"""
            <ZStack modifiers="[{&quot;horizontal&quot;:null,&quot;type&quot;:&quot;fixed_size&quot;,&quot;vertical&quot;:null}]">
                <Rectangle fill-color="system-red" />
                <Text>Hello, world!</Text>
            </ZStack>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            ZStack {
                Rectangle()
                    .fill(.red)
                Text("Hello, world!")
            }
                .fixedSize()
        }
        try assertMatch(
            #"""
            <ZStack modifiers="[{&quot;horizontal&quot;:null,&quot;type&quot;:&quot;fixed_size&quot;,&quot;vertical&quot;:true}]">
                <Rectangle fill-color="system-red" />
                <Text>Hello, world!</Text>
            </ZStack>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            ZStack {
                Rectangle()
                    .fill(.red)
                Text("Hello, world!")
            }
                .fixedSize(horizontal: false, vertical: true)
        }
        try assertMatch(
            #"""
            <ZStack modifiers="[{&quot;horizontal&quot;:true,&quot;type&quot;:&quot;fixed_size&quot;,&quot;vertical&quot;:null}]">
                <Rectangle fill-color="system-red" />
                <Text>Hello, world!</Text>
            </ZStack>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            ZStack {
                Rectangle()
                    .fill(.red)
                Text("Hello, world!")
            }
                .fixedSize(horizontal: true, vertical: false)
        }
    }
    
    func testLayoutPriority() throws {
        try assertMatch(
            #"""
            <HStack>
                <Rectangle fill-color="system-red" />
                <Rectangle fill-color="system-green" modifiers="[{&quot;type&quot;:&quot;layout_priority&quot;,&quot;value&quot;:1.0}]" />
                <Rectangle fill-color="system-blue" />
            </ZStack>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            HStack {
                Rectangle()
                    .fill(.red)
                Rectangle()
                    .fill(.green)
                    .layoutPriority(1)
                Rectangle()
                    .fill(.blue)
            }
        }
    }
    
    func testPosition() throws {
        try assertMatch(
            #"""
            <Text modifiers="[{&quot;type&quot;:&quot;position&quot;,&quot;x&quot;:0.0,&quot;y&quot;:0.0}]">0, 0</Text>
            <Text modifiers="[{&quot;type&quot;:&quot;position&quot;,&quot;x&quot;:50.0,&quot;y&quot;:25.0}]">50, 25</Text>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Text("0, 0")
                .position(x: 0, y: 0)
            Text("50, 25")
                .position(x: 50, y: 25)
        }
    }
    
    func testSafeAreaInset() throws {
        try assertMatch(
            #"""
            <ScrollView modifiers="[{&quot;alignment&quot;:&quot;center&quot;,&quot;content&quot;:&quot;content&quot;,&quot;edge&quot;:&quot;bottom&quot;,&quot;spacing&quot;:null,&quot;type&quot;:&quot;safe_area_inset&quot;}]">
                <Rectangle fill-color="system-red" />
                <Text template="content">Bottom Inset</Text>
            </ScrollView>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            ScrollView {
                Rectangle().fill(.red)
            }
                .safeAreaInset(edge: .bottom) {
                    Text("Bottom Inset")
                }
        }
    }
    
    func testFrame() throws {
        try assertMatch(
            #"""
            <Color name="system-pink" modifiers='[{"type": "frame", "width": 50, "height": 50, "alignment": "top"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Color.pink
                .frame(width: 50, height: 50, alignment: .top)
        }
        
        try assertMatch(
            #"""
            <Color name="system-pink" modifiers='[{"type": "frame", "ideal_width": 50, "max_width": 75, "ideal_height": 50, "max_height": 75, "alignment": "bottom"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Color.pink
                .frame(idealWidth: 50, maxWidth: 75, idealHeight: 50, maxHeight: 75, alignment: .bottom)
        }
    }
    
    func testPadding() throws {
        try assertMatch(
            #"""
            <Color name="system-pink" modifiers='[{"type": "padding", "length": 20, "edges": "all"}]' />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Color.pink
                .padding(20)
        }
    }
}
