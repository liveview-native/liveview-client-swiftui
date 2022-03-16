//
//  FragmentDecoderTests.swift
//  
//
//  Created by Shadowfacts on 3/21/22.
//

import XCTest
@testable import PhoenixLiveViewNative

class FragmentDecoderTests: XCTestCase {
    

    func testFragmentDecoder() throws {
        struct Test: Decodable, Equatable {
            let b: Bool
            let s: String
            let d: Double
            let f: Float
            let i: Int
            let o: Nested
            let a: [Nested]
        }
        struct Nested: Decodable, Equatable {
            let s: String
        }
        let data = """
        {
            "b": false,
            "s": "foo",
            "d": 1.1,
            "f": 2.2,
            "i": 3,
            "o": {
                "s": "bar"
            },
            "a": [
                {
                    "s": "foo",
                },
                {
                    "s": "bar",
                },
                {
                    "s": "baz",
                }
            ]
        }
        """.data(using: .utf8)!
        let json = try JSONSerialization.jsonObject(with: data)
        XCTAssertEqual(
            try Test(from: FragmentDecoder(data: json)),
            Test(b: false, s: "foo", d: 1.1, f: 2.2, i: 3, o: Nested(s: "bar"), a: [Nested(s: "foo"), Nested(s: "bar"), Nested(s: "baz")])
        )
    }

}
