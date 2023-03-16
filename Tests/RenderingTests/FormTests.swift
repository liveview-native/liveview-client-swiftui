//
//  FormTests.swift
//
//
//  Created by Carson Katri on 2/23/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

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

    func testFormStyles() throws {
        let markupContent = #"""
        <Text id="0">0</Text>
        <Text id="1">1</Text>
        <Text id="2">2</Text>
        """#
        @ViewBuilder
        var content: some View {
            Text("0")
            Text("1")
            Text("2")
        }
        try assertMatch(
            #"<Form form-style="automatic">\#(markupContent)</Form>"#,
            size: .init(width: 300, height: 300)
        ) {
            Form {
                content
            }
            .formStyle(.automatic)
        }
        try assertMatch(
            #"<Form form-style="columns">\#(markupContent)</Form>"#,
            size: .init(width: 300, height: 300)
        ) {
            Form {
                content
            }
            .formStyle(.columns)
        }
        try assertMatch(
            #"<Form form-style="grouped">\#(markupContent)</Form>"#,
            size: .init(width: 300, height: 300)
        ) {
            Form {
                content
            }
            .formStyle(.grouped)
        }
    }
    
    // MARK: LabeledContent
    
    func testLabeledContent() throws {
        try assertMatch(
            #"""
            <LabeledContent>
                <LabeledContent:label>Label</LabeledContent:label>
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
                <LabeledContent:label>Label</LabeledContent:label>
                <LabeledContent:content>Content</LabeledContent:content>
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
            #"<LabeledContent value="100" format="currency" currency-code="usd">Label</LabeledContent>"#,
            size: .init(width: 300, height: 100)
        ) {
            LabeledContent("Label", value: 100, format: .currency(code: "usd"))
        }
    }
}
