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
            <form>
                <text id="0">0</text>
                <text id="1">1</text>
                <text id="2">2</text>
            </form>
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
        <text id="0">0</text>
        <text id="1">1</text>
        <text id="2">2</text>
        """#
        @ViewBuilder
        var content: some View {
            Text("0")
            Text("1")
            Text("2")
        }
        try assertMatch(
            #"<form form-style="automatic">\#(markupContent)</form>"#,
            size: .init(width: 300, height: 300)
        ) {
            Form {
                content
            }
            .formStyle(.automatic)
        }
        try assertMatch(
            #"<form form-style="columns">\#(markupContent)</form>"#,
            size: .init(width: 300, height: 300)
        ) {
            Form {
                content
            }
            .formStyle(.columns)
        }
        try assertMatch(
            #"<form form-style="grouped">\#(markupContent)</form>"#,
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
            <labeled-content>
                <labeled-content:label>Label</labeled-content:label>
                Content
            </labeled-content>
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
            <labeled-content>
                <labeled-content:label>Label</labeled-content:label>
                <labeled-content:content>Content</labeled-content:content>
            </labeled-content>
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
            #"<labeled-content value="100" format="currency" currency-code="usd">Label</labeled-content>"#,
            size: .init(width: 300, height: 100)
        ) {
            LabeledContent("Label", value: 100, format: .currency(code: "usd"))
        }
    }
}
