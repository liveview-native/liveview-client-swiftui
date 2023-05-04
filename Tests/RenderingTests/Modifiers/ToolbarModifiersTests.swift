//
//  ToolbarModifiersTests.swift
//  
//
//  Created by Carson Katri on 5/4/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class ToolbarModifiersTests: XCTestCase {
    func testToolbarBackground() throws {
        try assertMatch(
            #"""
            <Rectangle fill-color="system-red" modifiers="[{&quot;bars&quot;:&quot;navigation_bar&quot;,&quot;style&quot;:{&quot;concrete_style&quot;:&quot;color&quot;,&quot;modifiers&quot;:[],&quot;style&quot;:{&quot;blue&quot;:null,&quot;brightness&quot;:null,&quot;green&quot;:null,&quot;hue&quot;:null,&quot;opacity&quot;:null,&quot;red&quot;:null,&quot;rgb_color_space&quot;:null,&quot;saturation&quot;:null,&quot;string&quot;:&quot;system-red&quot;,&quot;white&quot;:null}},&quot;type&quot;:&quot;toolbar_background&quot;,&quot;visibility&quot;:null}]">
            </Rectangle>
            """#,
            size: .init(width: 100, height: 100),
            lifetime: .keepAlways
        ) {
            Rectangle()
                .fill(.red)
                .toolbarBackground(.red, for: .navigationBar)
        }
    }
}
