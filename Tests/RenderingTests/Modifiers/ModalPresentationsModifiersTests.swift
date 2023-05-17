//
//  ModalPresentationsModifiersTests.swift
//  
//
//  Created by Carson Katri on 5/18/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class ModalPresentationsModifiersTests: XCTestCase {
    func testSheet() throws {
        try assertHierarchy(
            #"""
            <Rectangle fill-color="system-blue" modifiers='[{"content":"my_content","is_presented":"show","on_dismiss":null,"type":"sheet"}]'>
                <Rectangle fill-color="system-red" template="my_content" />
            </Rectangle>
            """#,
            outerView: {
                $0
                    .environmentObject(LiveViewModel(
                        forms: [:],
                        cachedNavigationTitle: nil,
                        bindingValues: ["show": true]
                    ))
            }
        ) {
            AnyShape(Rectangle())
                .fill(.blue)
                .sheet(isPresented: .constant(true)) {
                    AnyShape(Rectangle())
                        .fill(.red)
                }
        }
    }
    
    func testAlert() throws {
        try assertHierarchy(
            #"""
            <Rectangle fill-color="system-blue" modifiers='[{"actions":"actions","is_presented":"show","message":"message","title":"My Alert","type":"alert"}]'>
                <Text template="message">Message</Text>
                <Group template="actions">
                    <Button>Option #1</Button>
                    <Button>Option #2</Button>
                </Group>
            </Rectangle>
            """#,
            outerView: {
                $0
                    .environmentObject(LiveViewModel(
                        forms: [:],
                        cachedNavigationTitle: nil,
                        bindingValues: ["show": true]
                    ))
            }
        ) {
            AnyShape(Rectangle())
                .fill(.blue)
                .alert("My Alert", isPresented: .constant(true)) {
                    Button("Option #1") {}
                    Button("Option #2") {}
                } message: {
                    // Note: In some cases, wrapping content in an `if` provides a different hierarchy that matches LVN.
                    if true {
                        Text("Message")
                    }
                }
        }
    }
}
