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
        #if os(iOS)
        try assertMatch(
            #"""
            <Rectangle fill-color="system-red" modifiers="[{&quot;bars&quot;:&quot;navigation_bar&quot;,&quot;style&quot;:{&quot;concrete_style&quot;:&quot;color&quot;,&quot;modifiers&quot;:[],&quot;style&quot;:{&quot;blue&quot;:null,&quot;brightness&quot;:null,&quot;green&quot;:null,&quot;hue&quot;:null,&quot;opacity&quot;:null,&quot;red&quot;:null,&quot;rgb_color_space&quot;:null,&quot;saturation&quot;:null,&quot;string&quot;:&quot;system-blue&quot;,&quot;white&quot;:null}},&quot;type&quot;:&quot;toolbar_background&quot;,&quot;visibility&quot;:&quot;visible&quot;}]">
            </Rectangle>
            """#,
            size: .init(width: 100, height: 100),
            outerView: { content in
                NavigationView {
                    content
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("Title")
                }
            }
        ) {
            Rectangle()
                .fill(.red)
                .toolbarBackground(.blue, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
        #endif
    }
    
    func testToolbar() throws {
        #if os(iOS)
        try assertMatch(
            #"""
            <Rectangle fill-color="system-red" modifiers="[{&quot;content&quot;:&quot;content&quot;,&quot;id&quot;:null,&quot;type&quot;:&quot;toolbar&quot;}]">
                <Group template="content">
                    <ToolbarItem placement="confirmation-action">
                        <Button>Save</Button>
                    </ToolbarItem>
                    <ToolbarItem placement="cancellation-action">
                        <Button>Cancel</Button>
                    </ToolbarItem>
                </Group>
            </Rectangle>
            """#,
            size: .init(width: 300, height: 100),
            outerView: { content in
                NavigationView {
                    content
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("Title")
                }
            }
        ) {
            Rectangle()
                .fill(.red)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {}
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {}
                    }
                }
        }
        #endif
    }
    
    func testToolbarTitleMenu() throws {
        try assertMatch(
            #"""
            <Rectangle fill-color="system-red" modifiers="[{&quot;content&quot;:&quot;content&quot;,&quot;type&quot;:&quot;toolbar_title_menu&quot;}]">
                <Group template="content">
                    <Button>Save</Button>
                    <Button>Cancel</Button>
                </Group>
            </Rectangle>
            """#,
            size: .init(width: 300, height: 100),
            outerView: { content in
                NavigationView {
                    content
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("Title")
                }
            }
        ) {
            Rectangle()
                .fill(.red)
                .toolbarTitleMenu {
                    Button("Save") {}
                    Button("Cancel") {}
                }
        }
    }
    
    func testToolbarVisibility() throws {
        try assertMatch(
            #"""
            <Rectangle fill-color="system-red" modifiers="[{&quot;bars&quot;:&quot;navigation_bar&quot;,&quot;type&quot;:&quot;toolbar_visibility&quot;,&quot;visibility&quot;:&quot;hidden&quot;}]" />
            """#,
            size: .init(width: 100, height: 100),
            outerView: { content in
                NavigationView {
                    content
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("Title")
                }
            }
        ) {
            Rectangle()
                .fill(.red)
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}
