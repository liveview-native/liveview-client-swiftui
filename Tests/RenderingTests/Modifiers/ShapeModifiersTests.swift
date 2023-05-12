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
            <Circle modifiers="[{&quot;content&quot;:{&quot;concrete_style&quot;:&quot;color&quot;,&quot;modifiers&quot;:[],&quot;style&quot;:{&quot;blue&quot;:null,&quot;brightness&quot;:null,&quot;green&quot;:null,&quot;hue&quot;:null,&quot;opacity&quot;:null,&quot;red&quot;:null,&quot;rgb_color_space&quot;:null,&quot;saturation&quot;:null,&quot;string&quot;:&quot;system-red&quot;,&quot;white&quot;:null}},&quot;style&quot;:null,&quot;type&quot;:&quot;fill&quot;}]" />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Circle()
                .fill(.red)
        }
    }
}
