//
//  TextFieldTests.swift
//
//
//  Created by Carson Katri on 1/19/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class TextFieldTests: XCTestCase {
    func testSimple() throws {
        try assertMatch(#"<textfield placeholder="Type here" />"#) {
            TextField("Type here", text: .constant(""))
        }
        try assertMatch(#"<securefield placeholder="Password" />"#) {
            SecureField("Password", text: .constant(""))
        }
    }
    func testPrompt() throws {
        try assertMatch(#"<textfield placeholder="Placeholder" prompt="Prompt" />"#) {
            TextField("Placeholder", text: .constant(""), prompt: Text("Prompt"))
        }
        try assertMatch(#"<securefield placeholder="Placeholder" prompt="Prompt" />"#) {
            SecureField("Placeholder", text: .constant(""), prompt: Text("Prompt"))
        }
    }
}
