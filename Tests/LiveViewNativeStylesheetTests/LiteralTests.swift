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
        XCTAssertEqual(try AtomLiteral().parse(":value"), "value")
        XCTAssertEqual(try AtomLiteral().parse(#":"my-value""#), "my-value")
    }
    
    func testListLiteral() throws {
        XCTAssertEqual(try ListLiteral { StringLiteral() }.parse(#"["a", "b"]"#), ["a", "b"])
        XCTAssertEqual(try ListLiteral { AtomLiteral() }.parse("[:a, :b]"), ["a", "b"])
        XCTAssertEqual(
            try ListLiteral {
                ListLiteral {
                    StringLiteral()
                }
            }.parse(#"[["a", "b"], ["c"]]"#),
            [["a", "b"], ["c"]]
        )
    }
    
    func testNilLiteral() throws {
        XCTAssertNoThrow(try NilLiteral().parse("nil"))
        XCTAssertThrowsError(try NilLiteral().parse("null"))
    }
    
    func testStringLiteral() throws {
        XCTAssertEqual(try StringLiteral().parse(#""Hello, world!""#), "Hello, world!")
        XCTAssertEqual(try StringLiteral().parse(#""\"Hello, world!\"""#), "\"Hello, world!\"")
        XCTAssertEqual(try StringLiteral().parse(#""\\n""#), "\\n")
        XCTAssertEqual(try StringLiteral().parse(#""\/\b\f\n\r\t""#), "/\u{8}\u{c}\n\r\t")
    }
}
