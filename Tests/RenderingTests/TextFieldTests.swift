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
        try assertMatch(#"<text-field placeholder="Type here" />"#) {
            TextField("Type here", text: .constant(""))
        }
        try assertMatch(#"<secure-field placeholder="Password" />"#) {
            SecureField("Password", text: .constant(""))
        }
    }
    func testPrompt() throws {
        try assertMatch(#"<text-field placeholder="Placeholder" prompt="Prompt" />"#) {
            TextField("Placeholder", text: .constant(""), prompt: Text("Prompt"))
        }
        try assertMatch(#"<secure-field placeholder="Placeholder" prompt="Prompt" />"#) {
            SecureField("Placeholder", text: .constant(""), prompt: Text("Prompt"))
        }
    }
}
