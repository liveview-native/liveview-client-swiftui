//
//  FragmentTests.swift
//  
//
//  Created by Shadowfacts on 2/28/22.
//

import XCTest
@testable import LiveViewNative

extension Statics: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: String...) {
        self = .statics(elements)
    }
}

extension ComponentStatics: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: String...) {
        self = .statics(elements)
    }
}

extension Templates: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Int, [String])...) {
        self.init(templates: Dictionary(uniqueKeysWithValues: elements))
    }
}

extension Fragment {
    // helper so we don't need to construct a root in tests that don't need it
    func buildString() -> String {
        return buildString(root: Root(fragment: self, components: nil))
    }
}

class FragmentTests: XCTestCase {
    
    let decoder = JSONDecoder()

    func testDecodeStatics() throws {
        let data = """
        {"s": ["test"]}
        """.data(using: .utf8)!
        XCTAssertEqual(try decoder.decode(Fragment.self, from: data), .regular(children: [], statics: ["test"]))
    }
    
    func testDecodeNested() throws {
        let data = """
        {"0": {"s": ["test 2"]}, "s": ["test"]}
        """.data(using: .utf8)!
        XCTAssertEqual(try decoder.decode(Fragment.self, from: data), .regular(children: [.fragment(.regular(children: [], statics: ["test 2"]))], statics: ["test"]))
    }
    
    func testDecodeDynamicsWithoutValues() throws {
        let data = """
        {
            "0": {
                "d": [
                    [],
                    [],
                    []
                ],
                "s": [
                    "\\n  foo\\n"
                ]
            },
            "s": [
                "test\\n",
                ""
            ]
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(Fragment.self, from: data),
            .regular(children: [
                .fragment(.comprehension(dynamics: [
                    [],
                    [],
                    [],
                ], statics: [
                    "\n  foo\n"
                ], templates: nil))
            ], statics: [
                "test\n",
                "",
            ])
        )
    }
    
    func testDecodeDynamicsWithValues() throws {
        let data = """
        {
            "0": {
                "d": [
                    ["1"],
                    ["2"],
                    ["3"]
                ],
                "s": [
                    "\\n  foo ",
                    "\\n"
                ]
            },
            "s": [
                "test\\n",
                ""
            ]
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(Fragment.self, from: data),
            .regular(children: [
                .fragment(.comprehension(dynamics: [
                    [.string("1")],
                    [.string("2")],
                    [.string("3")],
                ], statics: [
                    "\n  foo ",
                    "\n"
                ], templates: nil))
            ], statics: [
                "test\n",
                "",
            ])
        )
    }
    
    func testDecodeDynamicsWithTemplates() throws {
        let data = """
        {
            "d": [
                [
                    "1",
                    {
                        "d": [["1"], ["2"]],
                        "s": 0
                    }
                ],
                [
                    "2",
                    {
                        "d": [["1"], ["2"]],
                        "s": 0
                    }
                ]
            ],
            "p": {
                "0": [
                    "\\n    bar ",
                    "\\n  "
                ]
            },
            "s": [
                "\\n  foo ",
                "\\n  ",
                "\\n"
            ]
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(Fragment.self, from: data),
            .comprehension(dynamics: [
                [
                    .string("1"),
                    .fragment(.comprehension(dynamics: [
                        [.string("1")],
                        [.string("2")]
                    ], statics: .templateRef(0), templates: nil))
                ],
                [
                    .string("2"),
                    .fragment(.comprehension(dynamics: [
                        [.string("1")],
                        [.string("2")]
                    ], statics: .templateRef(0), templates: nil))
                ]
            ], statics: [
                "\n  foo ",
                "\n  ",
                "\n"
            ], templates: [
                0: [
                    "\n    bar ",
                    "\n  "
                ]
            ])
        )
    }
    
    func testDecodeComponents() {
        let data = """
        {
            "0": {
                "0": 1,
                "s": [
                    "a ",
                    " b\\n"
                ]
            },
            "c": {
                "1": {
                    "0": "foo",
                    "s": [
                        "<p>test ",
                        "</p>"
                    ]
                }
            },
            "s": [
                "",
                ""
            ]
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(Root.self, from: data),
            Root(
                fragment: .regular(children: [
                    .fragment(.regular(children: [
                        .componentID(1)
                    ], statics: [
                        "a ",
                        " b\n"
                    ]))
                ], statics: [
                    "",
                    ""
                ]),
                components: [
                    1: Component(children: [
                        .string("foo")
                    ], statics: [
                        "<p>test ",
                        "</p>"
                    ])
                ]
            )
        )
    }
    
    func testDecodeComponentsWithSharedStatics() throws {
        let data = """
        {
            "0": {
                "0": 1,
                "1": 2,
                "s": [
                    "before ",
                    " middle ",
                    " after"
                ]
            },
            "c": {
                "1": {
                    "0": "a",
                    "s": [
                        "component_before ",
                        " component_after"
                    ]
                },
                "2": {
                    "0": "b",
                    "s": 1
                }
            },
            "s": [
                "",
                ""
            ]
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(Root.self, from: data),
            Root(
                fragment: .regular(children: [
                    .fragment(.regular(children: [
                        .componentID(1),
                        .componentID(2)
                    ], statics: [
                        "before ",
                        " middle ",
                        " after"
                    ]))
                ], statics: [
                    "",
                    ""
                ]),
                components: [
                    1: Component(children: [
                        .string("a")
                    ], statics: [
                        "component_before ",
                        " component_after"
                    ]),
                    2: Component(children: [
                        .string("b")
                    ], statics: .componentRef(1))
                ]
            )
        )
    }
    
    func testDecodeComponentWithDynamics() {
        let data = """
        {
            "0": {
                "0": 1,
                "s": [
                    "before ",
                    " after"
                ]
            },
            "c": {
                "1": {
                    "0": {
                        "d": [
                            ["0", "foo"],
                            ["0", "bar"]
                        ],
                        "s": [
                            "n: ",
                            ", s: ",
                            "\\n"
                        ]
                    },
                    "s": [
                        "<div>",
                        "</div>"
                    ]
                }
            },
            "s": [
                "",
                ""
            ]
        }
        """.data(using: .utf8)!
        XCTAssertEqual(
            try decoder.decode(Root.self, from: data),
            Root(fragment: .regular(children: [
                .fragment(.regular(children: [
                    .componentID(1)
                ], statics: [
                    "before ",
                    " after"
                ]))
            ], statics: [
                "",
                ""
            ]), components: [
                1: Component(children: [
                    .fragment(.comprehension(dynamics: [
                        [.string("0"), .string("foo")],
                        [.string("0"), .string("bar")],
                    ], statics: [
                        "n: ",
                        ", s: ",
                        "\n",
                    ], templates: nil))
                ], statics: [
                    "<div>",
                    "</div>"
                ])
            ])
        )
    }
    
    func testBuildStringStatic() {
        XCTAssertEqual(
            Fragment.regular(children: [], statics: ["test"]).buildString(),
            "test"
        )
    }
    
    func testBuildStringNested() {
        XCTAssertEqual(
            Fragment.regular(children: [
                .fragment(.regular(children: [], statics: ["test 2"]))
            ], statics: [
                "test ",
                ""
            ]).buildString(),
            "test test 2"
        )
    }

    func testBuildStringDynamicsWithoutValues() throws {
        XCTAssertEqual(
            Fragment.regular(children: [
                .fragment(.comprehension(dynamics: [
                    [],
                    [],
                    [],
                ], statics: [
                    "\n  foo\n"
                ], templates: nil))
            ], statics: [
                "test\n",
                "",
            ]).buildString(),
            "test\n\n  foo\n\n  foo\n\n  foo\n"
        )
    }
    
    func testBuildStringDynamicsWithValues() throws {
        XCTAssertEqual(
            Fragment.regular(children: [
                .fragment(.comprehension(dynamics: [
                    [.string("1")],
                    [.string("2")],
                    [.string("3")],
                ], statics: [
                    "\n  foo ",
                    "\n"
                ], templates: nil))
            ], statics: [
                "test\n",
                "",
            ]).buildString(),
            "test\n\n  foo 1\n\n  foo 2\n\n  foo 3\n"
        )
    }
    
    func testBuildStringDynamicsWithTemplates() throws {
        XCTAssertEqual(
            Fragment.comprehension(dynamics: [
                [
                    .string("1"),
                    .fragment(.comprehension(dynamics: [
                        [.string("1")],
                        [.string("2")]
                    ], statics: .templateRef(0), templates: nil))
                ],
                [
                    .string("2"),
                    .fragment(.comprehension(dynamics: [
                        [.string("1")],
                        [.string("2")]
                    ], statics: .templateRef(0), templates: nil))
                ]
            ], statics: [
                "\n  foo ",
                "\n  ",
                "\n"
            ], templates: [
                0: [
                    "\n    bar ",
                    "\n  "
                ]
            ]).buildString(),
            "\n  foo 1\n  \n    bar 1\n  \n    bar 2\n  \n\n  foo 2\n  \n    bar 1\n  \n    bar 2\n  \n"
        )
    }
    
    func testBuildStringComponents() throws {
        XCTAssertEqual(
            Root(
                fragment: .regular(children: [
                    .fragment(.regular(children: [
                        .componentID(1)
                    ], statics: [
                        "a ",
                        " b\n"
                    ]))
                ], statics: [
                    "",
                    ""
                ]),
                components: [
                    1: Component(children: [
                        .string("foo")
                    ], statics: [
                        "<p>test ",
                        "</p>"
                    ])
                ]
            ).buildString(),
            "a <p>test foo</p> b\n"
        )
    }
    
    func testBuildStringComponentWithSharedStatics() {
        XCTAssertEqual(
            Root(
                fragment: .regular(children: [
                    .fragment(.regular(children: [
                        .componentID(1),
                        .componentID(2)
                    ], statics: [
                        "before ",
                        " middle ",
                        " after"
                    ]))
                ], statics: [
                    "",
                    ""
                ]),
                components: [
                    1: Component(children: [
                        .string("a")
                    ], statics: [
                        "component_before ",
                        " component_after"
                    ]),
                    2: Component(children: [
                        .string("b")
                    ], statics: .componentRef(1))
                ]
            ).buildString(),
            "before component_before a component_after middle component_before b component_after after"
        )

    }
    
    func testBuildStringComponentWithDynamics() {
        XCTAssertEqual(
            Root(fragment: .regular(children: [
                .fragment(.regular(children: [
                    .componentID(1)
                ], statics: [
                    "before ",
                    " after"
                ]))
            ], statics: [
                "",
                ""
            ]), components: [
                1: Component(children: [
                    .fragment(.comprehension(dynamics: [
                        [.string("0"), .string("foo")],
                        [.string("0"), .string("bar")],
                    ], statics: [
                        "n: ",
                        ", s: ",
                        "\n",
                    ], templates: nil))
                ], statics: [
                    "<div>",
                    "</div>"
                ])
            ]).buildString(),
            "before <div>n: 0, s: foo\nn: 0, s: bar\n</div> after"
        )
    }
    
    func testBuildStringWithNestedComprehensions() throws {
        XCTAssertEqual(
            Root(fragment: .comprehension(
                dynamics: [
                    [.fragment(.comprehension(dynamics: [[.string("0")], [.string("1")]], statics: .templateRef(0), templates: nil))],
                    [.fragment(.comprehension(dynamics: [[.string("0")], [.string("1")]], statics: .templateRef(0), templates: nil))]
                ], statics: .statics([
                    "\n  ",
                    "\n"
                ]),
                templates: [
                    0: [
                        "\n    ",
                        "\n  "
                    ]
                ]),
                 components: nil
            ).buildString(),
            "\n  \n    0\n  \n    1\n  \n\n  \n    0\n  \n    1\n  \n"
        )
    }

}
