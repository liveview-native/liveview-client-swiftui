//
//  ExternalTests.swift
//
//
//  Created by Carson Katri on 1/4/24.
//

import XCTest
import SwiftUI
@testable import LiveViewNativeStylesheet

final class ExternalTests: XCTestCase {
    func testASTNode() throws {
        XCTAssertEqual(
            try ASTNode("node") {
                StringLiteral()
            }
                .parse(#"{:node, [], "Hello, world!"}"#)
                .value,
            "Hello, world!"
        )
    }
    
    func testChainedMemberExpression() throws {
        let value = try ChainedMemberExpression {
            AtomLiteral()
        } member: {
            AtomLiteral()
        }
            .parse(#"{:., [], [nil, {:., [], [:a, :b]}]}"#)
        XCTAssertEqual(value.base, "a")
        XCTAssertEqual(value.members, ["b"])
    }
    
    func testImplicitStaticMember() throws {
        let parser = ImplicitStaticMember([
            "a": "A",
            "b": "B",
            "c": "C"
        ])
        XCTAssertEqual(try parser.parse("{:., [], [nil, :a]}"), "A")
        XCTAssertEqual(try parser.parse("{:., [], [nil, :b]}"), "B")
        XCTAssertEqual(try parser.parse("{:., [], [nil, :c]}"), "C")
    }
    
    func testMemberExpression() throws {
        let value = try MemberExpression {
            AtomLiteral()
        } member: {
            AtomLiteral()
        }.parse("{:., [], [:a, :b]}")
        XCTAssertEqual(value.base, "a")
        XCTAssertEqual(value.member, "b")
    }
    
    func testMetadata() throws {
        XCTAssertEqual(try Metadata.parser().parse("[]"), Metadata(file: "", line: 0, module: "", source: ""))
        XCTAssertEqual(
            try Metadata.parser().parse(
                #"[file: "test.ex", line: 5, module: MyApp.Module, source: "source code"]"#
            ),
            Metadata(file: "test.ex", line: 5, module: "MyApp.Module", source: "source code")
        )
    }
}
