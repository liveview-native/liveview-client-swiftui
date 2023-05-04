//
//  NavigationModifiersTests.swift
//
//
//  Created by Carson Katri on 5/4/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class NavigationModifiersTests: XCTestCase {
    func testTabItem() throws {
        #if os(iOS)
        try assertMatch(
            #"""
            <TabView modifiers="[{&quot;style&quot;:&quot;page_always&quot;,&quot;type&quot;:&quot;tab_view_style&quot;}]">
                <Text modifiers="[{&quot;label&quot;:&quot;label&quot;,&quot;type&quot;:&quot;tab_item&quot;}]">
                    A
                    <Image template="label" system-name="person.crop.circle.fill" />
                </Text>
                <Text modifiers="[{&quot;label&quot;:&quot;label&quot;,&quot;type&quot;:&quot;tab_item&quot;}]">
                    B
                    <Image template="label" system-name="tray.fill" />
                </Text>
            </TabView>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            TabView {
                Text("A")
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                    }
                Text("B")
                    .tabItem {
                        Image(systemName: "tray.fill")
                    }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        #endif
    }
    
    func testTabViewStyle() throws {
        let content = #"""
        <Text modifiers="[{&quot;label&quot;:&quot;label&quot;,&quot;type&quot;:&quot;tab_item&quot;}]">
            A
            <Image template="label" system-name="person.crop.circle.fill" />
        </Text>
        """#
        let contentView = Text("A")
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
            }
        #if os(iOS)
        try assertMatch(
            #"""
            <TabView modifiers="[{&quot;style&quot;:&quot;page&quot;,&quot;type&quot;:&quot;tab_view_style&quot;}]">
                \#(content)
            </TabView>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            TabView {
                contentView
            }
            .tabViewStyle(.page)
        }
        try assertMatch(
            #"""
            <TabView modifiers="[{&quot;style&quot;:&quot;page_always&quot;,&quot;type&quot;:&quot;tab_view_style&quot;}]">
                \#(content)
            </TabView>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            TabView {
                contentView
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        try assertMatch(
            #"""
            <TabView modifiers="[{&quot;style&quot;:&quot;page_never&quot;,&quot;type&quot;:&quot;tab_view_style&quot;}]">
                \#(content)
            </TabView>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            TabView {
                contentView
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        #endif
    }
}
