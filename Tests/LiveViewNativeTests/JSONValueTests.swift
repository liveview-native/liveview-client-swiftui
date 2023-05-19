//
//  JSONValueTests.swift
//  
//
//  Created by Shadowfacts on 5/19/23.
//

import XCTest
@testable import LiveViewNative

final class JSONValueTests: XCTestCase {

    func testHeterogenousCollections() {
        let object: JSONValue = [
            // todo: without the explicit cast, this nil can't be inferred as a JSONValue for some reason
            "key1": nil as JSONValue,
            "key2": 3.14,
            "key3": "foo",
            "key4": [
                ["bar": false, "baz": 42],
                "qux",
            ],
        ]
        XCTAssertEqual(object, .object([
            "key1": .null,
            "key2": .double(3.14),
            "key3": .string("foo"),
            "key4": .array([
                .object(["bar": .boolean(false), "baz": .integer(42)]),
                .string("qux"),
            ])
        ]))
    }
    
}
