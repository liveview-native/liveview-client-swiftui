//
//  FragmentDiffTests.swift
//  
//
//  Created by Shadowfacts on 3/4/22.
//

import XCTest
@testable import PhoenixLiveViewNative

class FragmentDiffTests: XCTestCase {
    
    let decoder = JSONDecoder()
    
    func testDecodeReplace() throws {
        let data = """
        {
            "0": "foo",
            "1": "bar",
            "s": [
                "a",
                "b"
            ]
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(FragmentDiff.self, from: data),
            .replaceCurrent(.regular(children: [
                .string("foo"),
                .string("bar")
            ], statics: [
                "a",
                "b",
            ]))
        )
    }

    func testDecodeSimple() throws {
        let data = """
        {
            "1": "baz"
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(FragmentDiff.self, from: data),
            .updateRegular(children: [
                1: .string("baz"),
            ])
        )
    }
    
    func testDecodeComprehension() throws {
        let data = """
        {
            "d": [
                ["foo", 1],
                ["bar", 1]
            ]
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(FragmentDiff.self, from: data),
            .updateComprehension(dynamics: [
                [.string("foo"), .componentID(1)],
                [.string("bar"), .componentID(1)],
            ])
        )
    }
    
    func testDecodeComponentDiff() throws {
        let data = """
        {
            "0": {
                "0": 1
            },
            "c": {
                "1": {
                    "0": {
                        "d": [
                            [
                                "0",
                                "foo"
                            ],
                            [
                                "1",
                                "bar"
                            ]
                        ]
                    }
                }
            }
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(RootDiff.self, from: data),
            RootDiff(
                fragment: .updateRegular(children: [
                    0: .fragment(.updateRegular(children: [
                        0: .componentID(1)
                    ]))
                ]),
                components: [
                    1: .updateRegular(children: [
                        0: .fragment(.updateComprehension(dynamics: [
                            [.string("0"), .string("foo")],
                            [.string("1"), .string("bar")],
                        ]))
                    ])
                ]
            )
        )
    }

}
