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
            try JSONDecoder().decode(ASTNode.self, from: Data(#"["node", {}, ["Hello, world!"]]"#.utf8)),
            ASTNode(identifier: "node", annotations: .init(), arguments: [.unlabeled(.string("Hello, world!"))])
        )
    }
    
    func testAnnotations() throws {
        XCTAssertEqual(
            try JSONDecoder().decode(Annotations.self, from: Data("{}".utf8)),
            Annotations()
        )
        XCTAssertEqual(
            try JSONDecoder().decode(Annotations.self, from: Data(#"{ "file": "file", "line": 1, "module": "module", "source": "source" }"#.utf8)),
            Annotations(file: "file", line: 1, module: "module", source: "source")
        )
    }
}
