//
//  ViewStylesModifiersTests.swift
//
//
//  Created by Carson Katri on 5/4/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class ViewStylesModifiersTests: XCTestCase {
    func testIndexViewStyle() throws {
        #if os(iOS)
        let tabView = TabView {
            Text("A")
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                }
            Text("B")
                .tabItem {
                    Image(systemName: "tray.fill")
                }
        }
            .tabViewStyle(.page)
        let content = #"""
        <Text modifiers="[{&quot;label&quot;:&quot;label&quot;,&quot;type&quot;:&quot;tab_item&quot;}]">
            A
            <Image template="label" system-name="person.crop.circle.fill" />
        </Text>
        <Text modifiers="[{&quot;label&quot;:&quot;label&quot;,&quot;type&quot;:&quot;tab_item&quot;}]">
            B
            <Image template="label" system-name="tray.fill" />
        </Text>
        """#
        try assertMatch(
            #"""
            <TabView
                modifiers="[{&quot;style&quot;:&quot;page&quot;,&quot;type&quot;:&quot;tab_view_style&quot;},{&quot;style&quot;:&quot;page_always&quot;,&quot;type&quot;:&quot;index_view_style&quot;}]"
            >
                \#(content)
            </TabView>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            tabView
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        try assertMatch(
            #"""
            <TabView
                modifiers="[{&quot;style&quot;:&quot;page&quot;,&quot;type&quot;:&quot;tab_view_style&quot;},{&quot;style&quot;:&quot;page_never&quot;,&quot;type&quot;:&quot;index_view_style&quot;}]"
            >
                \#(content)
            </TabView>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            tabView
            .indexViewStyle(.page(backgroundDisplayMode: .never))
        }
        #endif
    }
}
