//
//  FragmentEncoderTests.swift
//  
//
//  Created by Shadowfacts on 1/27/23.
//

import XCTest
@testable import LiveViewNative

final class FragmentEncoderTests: XCTestCase {

    func testFragmentEncoder() throws {
        struct Test: Encodable, Equatable {
            let b: Bool
            let s: String
            let d: Double
            let f: Float
            let i: Int
            let o: Nested
            let a: [Nested]
        }
        struct Nested: Encodable, Equatable {
            let s: String
        }
        let expected: [String: Any?] = [
            "b": false,
            "s": "hello",
            "d": 3.14,
            "f": 1.0,
            "i": -1,
            "o": [
                "s": "foo"
            ],
            "a": [
                [
                    "s": "bar"
                ]
            ]
        ]
        let test = Test(b: false, s: "hello", d: 3.14, f: 1.0, i: -1, o: Nested(s: "foo"), a: [Nested(s: "bar")])
        let encoder = FragmentEncoder()
        try test.encode(to: encoder)
        XCTAssertEqual(encoder.toNSJSONSerializable() as! NSDictionary, expected as NSDictionary)
    }
    
}
