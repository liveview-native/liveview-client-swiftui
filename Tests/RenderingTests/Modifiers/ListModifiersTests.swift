//
//  ListsModifiersTests.swift
//
//
//  Created by Carson Katri on 5/4/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class ListsModifiersTests: XCTestCase {
    func testHeaderProminence() throws {
        try assertMatch(
            #"""
            <List modifiers="[{&quot;prominence&quot;:&quot;increased&quot;,&quot;type&quot;:&quot;header_prominence&quot;}]">
                <Section id="a">
                    <Text template="header">Section A</Text>
                    <Text>A</Text>
                </Section>
                <Section id="b">
                    <Text template="header">Section B</Text>
                    <Text>B</Text>
                </Section>
                <Text id="c">C</Text>
            </List>
            """#,
            size: .init(width: 200, height: 300)
        ) {
            List {
                Section("Section A") {
                    Text("A")
                }
                Section("Section B") {
                    Text("B")
                }
                Text("C")
            }
            .headerProminence(.increased)
        }
    }
    
    func testListItemTint() throws {
        try assertMatch(
            #"""
            <List>
                <Label system-image="gear" id="gear">Default</Label>
                <Label
                    modifiers="[{&quot;tint&quot;:{&quot;color&quot;:null,&quot;type&quot;:&quot;monochrome&quot;},&quot;type&quot;:&quot;list_item_tint&quot;}]"
                    system-image="square.lefthalf.filled" id="monochrome"
                >
                    Monochrome
                </Label>
                <Label
                    modifiers="[{&quot;tint&quot;:{&quot;color&quot;:{&quot;blue&quot;:null,&quot;brightness&quot;:null,&quot;green&quot;:null,&quot;hue&quot;:null,&quot;opacity&quot;:null,&quot;red&quot;:null,&quot;rgb_color_space&quot;:null,&quot;saturation&quot;:null,&quot;string&quot;:&quot;system-red&quot;,&quot;white&quot;:null},&quot;type&quot;:&quot;fixed&quot;},&quot;type&quot;:&quot;list_item_tint&quot;}]"
                    system-image="paintpalette.fill" id="fixed"
                >
                    Fixed Red
                </Label>
                <Label
                    modifiers="[{&quot;tint&quot;:{&quot;color&quot;:{&quot;blue&quot;:null,&quot;brightness&quot;:null,&quot;green&quot;:null,&quot;hue&quot;:null,&quot;opacity&quot;:null,&quot;red&quot;:null,&quot;rgb_color_space&quot;:null,&quot;saturation&quot;:null,&quot;string&quot;:&quot;system-red&quot;,&quot;white&quot;:null},&quot;type&quot;:&quot;preferred&quot;},&quot;type&quot;:&quot;list_item_tint&quot;}]"
                    system-image="swatchpalette.fill" id="preferred"
                >
                    Preferred Red
                </Label>
            </List>
            """#,
            size: .init(width: 200, height: 300)
        ) {
            List {
                Label("Default", systemImage: "gear")
                Label("Monochrome", systemImage: "square.lefthalf.filled")
                    .listItemTint(.monochrome)
                Label("Fixed Red", systemImage: "paintpalette.fill")
                    .listItemTint(.fixed(.red))
                Label("Preferred Red", systemImage: "swatchpalette.fill")
                    .listItemTint(.preferred(.red))
            }
        }
    }
    
    func testListRowBackground() throws {
        try assertMatch(
            #"""
            <List>
                <Text id="row" modifiers="[{&quot;content&quot;:&quot;my_background&quot;,&quot;type&quot;:&quot;list_row_background&quot;}]">
                    Row
                    <Capsule template="my_background" fill-color="system-red" />
                </Text>
            </List>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            List {
                Text("Row")
                    .listRowBackground(Capsule().fill(.red))
            }
        }
    }
    
    func testListRowSeparatorTint() throws {
        #if os(iOS)
        try assertMatch(
            #"""
            <List>
               <Text
                   modifiers="[{&quot;color&quot;:{&quot;blue&quot;:null,&quot;brightness&quot;:null,&quot;green&quot;:null,&quot;hue&quot;:null,&quot;opacity&quot;:null,&quot;red&quot;:null,&quot;rgb_color_space&quot;:null,&quot;saturation&quot;:null,&quot;string&quot;:&quot;system-blue&quot;,&quot;white&quot;:null},&quot;edges&quot;:&quot;bottom&quot;,&quot;type&quot;:&quot;list_row_separator_tint&quot;}]"
                   id="blue"
               >
                   Blue Below
               </Text>
               <Text id="neutral">
                   Neutral
               </Text>
               <Text
                   modifiers="[{&quot;color&quot;:{&quot;blue&quot;:null,&quot;brightness&quot;:null,&quot;green&quot;:null,&quot;hue&quot;:null,&quot;opacity&quot;:null,&quot;red&quot;:null,&quot;rgb_color_space&quot;:null,&quot;saturation&quot;:null,&quot;string&quot;:&quot;system-green&quot;,&quot;white&quot;:null},&quot;edges&quot;:&quot;top&quot;,&quot;type&quot;:&quot;list_row_separator_tint&quot;}]"
                   id="green"
               >
                   Green Above
               </Text>
            </List>
            """#,
            size: .init(width: 200, height: 400)
        ) {
            List {
                Text("Blue Below")
                    .listRowSeparatorTint(.blue, edges: .bottom)
                Text("Neutral")
                Text("Green Above")
                    .listRowSeparatorTint(.green, edges: .top)
            }
        }
        #endif
    }
    
    func testListSectionSeparator() throws {
        #if os(iOS)
        try assertMatch(
            #"""
            <List modifiers="[{&quot;style&quot;:&quot;plain&quot;,&quot;type&quot;:&quot;list_style&quot;}]">
                <Section modifiers="[{&quot;edges&quot;:&quot;all&quot;,&quot;type&quot;:&quot;list_section_separator&quot;,&quot;visibility&quot;:&quot;hidden&quot;}]" id="hidden">
                    <Text>A</Text>
                </Section>
                <Section id="default">
                    <Text>B</Text>
                </Section>
            </List>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            List {
                Section {
                    Text("A")
                }
                .listSectionSeparator(.hidden)
                Section {
                    Text("B")
                }
            }
            .listStyle(.plain)
        }
        #endif
    }
    
    func testListSectionSeparatorTint() throws {
        #if os(iOS)
        try assertMatch(
            #"""
            <List modifiers="[{&quot;style&quot;:&quot;plain&quot;,&quot;type&quot;:&quot;list_style&quot;}]">
                <Section modifiers="[{&quot;color&quot;:{&quot;blue&quot;:null,&quot;brightness&quot;:null,&quot;green&quot;:null,&quot;hue&quot;:null,&quot;opacity&quot;:null,&quot;red&quot;:null,&quot;rgb_color_space&quot;:null,&quot;saturation&quot;:null,&quot;string&quot;:&quot;system-blue&quot;,&quot;white&quot;:null},&quot;edges&quot;:&quot;bottom&quot;,&quot;type&quot;:&quot;list_section_separator_tint&quot;}]" id="blue">
                    <Text>Blue</Text>
                </Section>
                <Section modifiers="[{&quot;color&quot;:{&quot;blue&quot;:null,&quot;brightness&quot;:null,&quot;green&quot;:null,&quot;hue&quot;:null,&quot;opacity&quot;:null,&quot;red&quot;:null,&quot;rgb_color_space&quot;:null,&quot;saturation&quot;:null,&quot;string&quot;:&quot;system-green&quot;,&quot;white&quot;:null},&quot;edges&quot;:&quot;all&quot;,&quot;type&quot;:&quot;list_section_separator_tint&quot;}]" id="green">
                    <Text>Green</Text>
                </Section>
            </List>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            List {
                Section {
                    Text("Blue")
                }
                .listSectionSeparatorTint(.blue, edges: .bottom)
                Section {
                    Text("Green")
                }
                .listSectionSeparatorTint(.green)
            }
            .listStyle(.plain)
        }
        #endif
    }
    
    func testListStyle() throws {
        #if os(iOS)
        let content = #"""
        <Text id="a">A</Text>
        <Text id="b">B</Text>
        <Text id="c">C</Text>
        """#
        let contentView = Group {
            Text("A")
            Text("B")
            Text("C")
        }
        try assertMatch(
            #"""
            <List modifiers="[{&quot;style&quot;:&quot;automatic&quot;,&quot;type&quot;:&quot;list_style&quot;}]">
                \#(content)
            </List>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            List {
                contentView
            }
            .listStyle(.automatic)
        }
        try assertMatch(
            #"""
            <List modifiers="[{&quot;style&quot;:&quot;grouped&quot;,&quot;type&quot;:&quot;list_style&quot;}]">
                \#(content)
            </List>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            List {
                contentView
            }
            .listStyle(.grouped)
        }
        try assertMatch(
            #"""
            <List modifiers="[{&quot;style&quot;:&quot;inset&quot;,&quot;type&quot;:&quot;list_style&quot;}]">
                \#(content)
            </List>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            List {
                contentView
            }
            .listStyle(.inset)
        }
        try assertMatch(
            #"""
            <List modifiers="[{&quot;style&quot;:&quot;inset_grouped&quot;,&quot;type&quot;:&quot;list_style&quot;}]">
                \#(content)
            </List>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            List {
                contentView
            }
            .listStyle(.insetGrouped)
        }
        try assertMatch(
            #"""
            <List modifiers="[{&quot;style&quot;:&quot;plain&quot;,&quot;type&quot;:&quot;list_style&quot;}]">
                \#(content)
            </List>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            List {
                contentView
            }
            .listStyle(.plain)
        }
        try assertMatch(
            #"""
            <List modifiers="[{&quot;style&quot;:&quot;sidebar&quot;,&quot;type&quot;:&quot;list_style&quot;}]">
                \#(content)
            </List>
            """#,
            size: .init(width: 100, height: 100)
        ) {
            List {
                contentView
            }
            .listStyle(.sidebar)
        }
        #endif
    }
}
