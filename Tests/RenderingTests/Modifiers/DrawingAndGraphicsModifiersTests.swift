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
}
