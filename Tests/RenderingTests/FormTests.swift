//
//  FormTests.swift
//
//
//  Created by Carson Katri on 2/23/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class FormTests: XCTestCase {
    // MARK: Form

    func testForm() throws {
        try assertMatch(
            #"""
            <Form>
                <Text id="0">0</Text>
                <Text id="1">1</Text>
                <Text id="2">2</Text>
            </Form>
            """#,
            size: .init(width: 300, height: 300)
        ) {
            Form {
                Text("0")
                Text("1")
                Text("2")
            }
        }
    }
    
    // MARK: LabeledContent
    
    func testLabeledContent() throws {
        try assertMatch(
            #"""
            <LabeledContent>
                <Text template="label">Label</Text>
                Content
            </LabeledContent>
            """#,
            size: .init(width: 300, height: 100)
        ) {
            LabeledContent {
                Text("Content")
            } label: {
                Text("Label")
            }
        }
    }
    
    func testLabeledContentSlots() throws {
        try assertMatch(
            #"""
            <LabeledContent>
                <Text template="label">Label</Text>
                <Text template="content">Content</Text>
            </LabeledContent>
            """#,
            size: .init(width: 300, height: 100)
        ) {
            LabeledContent {
                Text("Content")
            } label: {
                Text("Label")
            }
        }
    }
    
    func testLabeledContentFormat() throws {
        try assertMatch(
            #"<LabeledContent value="100" format="currency" currencyCode="usd">Label</LabeledContent>"#,
            size: .init(width: 300, height: 100)
        ) {
            LabeledContent("Label", value: 100, format: .currency(code: "usd"))
        }
    }
}
