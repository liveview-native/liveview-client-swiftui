//
//  LiteralTests.swift
//
//
//  Created by Carson Katri on 1/4/24.
//

import XCTest
import SwiftUI
@testable import LiveViewNativeStylesheet

final class LiteralTests: XCTestCase {
    func testAtomLiteral() throws {
        XCTAssertEqual(
            try JSONDecoder().decode(AtomLiteral.self, from: Data(#"[":", {}, "value"]"#.utf8)).value,
            AtomLiteral("value").value
        )
        XCTAssertEqual(
            try JSONDecoder().decode(AtomLiteral.self, from: Data(#"[":", {}, "my-value"]"#.utf8)).value,
            AtomLiteral("my-value").value
        )
    }
}
