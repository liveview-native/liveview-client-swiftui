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
            <TabView modifiers='[{"style":"page_always","type":"tab_view_style"}]'>
                <Text modifiers='[{"label":"label","type":"tab_item"}]'>
                    A
                    <Image template="label" system-name="person.crop.circle.fill" />
                </Text>
                <Text modifiers='[{"label":"label","type":"tab_item"}]'>
                    B
                    <Image template="label" system-name="tray.fill" />
                </Text>
            </TabView>
            """#,
            size: .init(width: 200, height: 200)
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
        <Text modifiers='[{"label":"label","type":"tab_item"}]'>
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
            <TabView modifiers='[{"style":"page","type":"tab_view_style"}]'>
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
            <TabView modifiers='[{"style":"page_always","type":"tab_view_style"}]'>
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
            <TabView modifiers='[{"style":"page_never","type":"tab_view_style"}]'>
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
