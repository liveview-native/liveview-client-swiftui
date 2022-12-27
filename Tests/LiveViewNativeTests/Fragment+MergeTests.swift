//
//  Fragment+MergeTests.swift
//  
//
//  Created by Shadowfacts on 3/4/22.
//

import XCTest
@testable import LiveViewNative

class Fragment_MergeTests: XCTestCase {

    func testReplace() throws {
        let current = Fragment.regular(children: [
            .string("a")
        ], statics: [
            "b",
            "c"
        ])
        let new = Fragment.regular(children: [
            .string("foo")
        ], statics: [
            "bar",
            "baz"
        ])
        let diff = FragmentDiff.replaceCurrent(new)
        XCTAssertEqual(try current.merge(with: diff), new)
    }
    
    func testUpdateChildren() throws {
        let current = Fragment.regular(children: [
            .string("a"),
            .string("b"),
        ], statics: [
            "foo",
            "bar"
        ])
        let diff = FragmentDiff.updateRegular(children: [
            1: .string("c")
        ])
        XCTAssertEqual(
            try current.merge(with: diff),
            Fragment.regular(children: [
                .string("a"),
                .string("c"),
            ], statics: [
                "foo",
                "bar"
            ])
        )
    }
    
    func testUpdateComprehension() throws {
        let current = Fragment.comprehension(dynamics: [
            [.string("a"), .string("foo")],
            [.string("a"), .string("bar")],
        ], statics: [
            "1",
            "2",
            "3"
        ], templates: nil)
        let diff = FragmentDiff.updateComprehension(dynamics: [
            [.string("b"), .string("foo")],
            [.string("b"), .string("bar")],
        ], templates: nil)
        XCTAssertEqual(
            try current.merge(with: diff),
            .comprehension(dynamics: [
                [.string("b"), .string("foo")],
                [.string("b"), .string("bar")],
            ], statics: [
                "1",
                "2",
                "3"
            ], templates: nil)
        )
    }
    
    func testUpdateComprehensionWithTemplates() throws {
        let current = Fragment.comprehension(dynamics: [
            [.string("a"), .string("foo")],
            [.string("a"), .string("bar")],
        ], statics: [
            "1",
            "2",
            "3"
        ], templates: [
            0: ["a", "b"],
        ])
        let diff = FragmentDiff.updateComprehension(dynamics: [
            [.string("b"), .string("foo")],
            [.string("b"), .string("bar")],
        ], templates: [
            1: ["c"]
        ])
        XCTAssertEqual(
            try current.merge(with: diff),
            .comprehension(dynamics: [
                [.string("b"), .string("foo")],
                [.string("b"), .string("bar")],
            ], statics: [
                "1",
                "2",
                "3"
            ], templates: [
                // TODO: I'm not entirely certain merging this is the correct behavior, or if existing templates should be overwritten
                0: ["a", "b"],
                1: ["c"]
            ])
        )
    }
    
    func testUpdateExistingComponent() throws {
        let current = [
            1: Component(children: [
                .string("foo")
            ], statics: [
                "1",
                "2",
            ])
        ]
        let diff: [Int: ComponentDiff] = [
            1: .updateRegular(children: [
                0: .string("bar")
            ])
        ]
        XCTAssertEqual(
            try current.merge(with: diff),
            [
                1: Component(children: [
                    .string("bar")
                ], statics: [
                    "1",
                    "2"
                ])
            ]
        )
    }
    
    func testAddNewComponent() throws {
        let current = [
            1: Component(children: [
                .string("foo")
            ], statics: [
                "1",
                "2",
            ])
        ]
        let diff: [Int: ComponentDiff] = [
            2: .replaceCurrent(Component(children: [
                .string("bar")
            ], statics: [
                "3",
                "4"
            ]))
        ]
        XCTAssertEqual(
            try current.merge(with: diff),
            [
                1: Component(children: [
                    .string("foo")
                ], statics: [
                    "1",
                    "2"
                ]),
                2: Component(children: [
                    .string("bar")
                ], statics: [
                    "3",
                    "4"
                ])
            ]
        )
    }
    
    func testAddNewComponentReferencingExistingStatics() throws {
        let current = [
            1: Component(children: [
                .string("foo")
            ], statics: [
                "1",
                "2",
            ])
        ]
        let diff: [Int: ComponentDiff] = [
            2: .replaceCurrent(Component(children: [
                .string("bar")
            ], statics: .componentRef(-1)))
        ]
        XCTAssertEqual(
            try current.merge(with: diff),
            [
                1: Component(children: [
                    .string("foo")
                ], statics: [
                    "1",
                    "2"
                ]),
                2: Component(children: [
                    .string("bar")
                ], statics: .componentRef(1))
            ]
        )
    }
    
    func testAddComponentsToRoot() throws {
        let current = Root(fragment: .regular(children: [
            .string("foo")
        ], statics: [
            "1",
            "2"
        ]), components: nil)
        let diff = RootDiff(
            fragment: .replaceCurrent(.regular(children: [
                .string("foo"),
                .componentID(1)
            ], statics: [
                "1",
                "2",
                "3"
            ])),
            components: [
                1: .replaceCurrent(Component(children: [
                    .string("bar")
                ], statics: [
                    "4",
                    "5"
                ]))
            ]
        )
        XCTAssertEqual(
            try current.merge(with: diff),
            Root(fragment: .regular(children: [
                .string("foo"),
                .componentID(1)
            ], statics: [
                "1",
                "2",
                "3"
            ]), components: [
                1: Component(children: [
                    .string("bar")
                ], statics: [
                    "4",
                    "5"
                ])
            ])
        )
    }
    
    func testMergeNewFragmentChildIntoNonFragment() throws {
        var current = Child.string("a")
        let diff = ChildDiff.fragment(.replaceCurrent(.regular(children: [
            .string("b")
        ], statics: [
            "1",
            "2"
        ])))
        try current.merge(with: diff)
        XCTAssertEqual(
            current,
            .fragment(.regular(children: [
                .string("b")
            ], statics: [
                "1",
                "2"
            ]))
        )
    }
    
    func testFailToMergeFragmentMismatch() {
        let current = Fragment.regular(children: [
            .string("foo")
        ], statics: [
            "1",
            "2"
        ])
        let diff = FragmentDiff.updateComprehension(dynamics: [
            [.string("a"), .string("b")]
        ], templates: nil)
        XCTAssertThrowsError(try current.merge(with: diff)) { error in
            XCTAssertEqual(error as! MergeError, MergeError.fragmentTypeMismatch)
        }
    }
    
    func testFailToMergeChildMismatch() {
        var current = Child.string("a")
        let diff = ChildDiff.fragment(.updateRegular(children: [
            0: .string("b")
        ]))
        XCTAssertThrowsError(try current.merge(with: diff)) { error in
            XCTAssertEqual(error as! MergeError, MergeError.createChildFromUpdateFragment)
        }
    }
    
    func testFailToCreateComponentFromUpdate() {
        let diff = ComponentDiff.updateRegular(children: [
            1: .string("b")
        ])
        XCTAssertThrowsError(try diff.toNewComponent()) { error in
            XCTAssertEqual(error as! MergeError, MergeError.createComponentFromUpdate)
        }
    }
    
    func testFailToCreateChildFromUpdate() {
        let diff = ChildDiff.fragment(.updateRegular(children: [
            1: .string("a")
        ]))
        XCTAssertThrowsError(try diff.toNewChild()) { error in
            XCTAssertEqual(error as! MergeError, MergeError.createChildFromUpdateFragment)
        }
    }
    
    func testFailToAddRegularChild() {
        let current = Fragment.regular(children: [
            .string("a")
        ], statics: [
            "1",
            "2"
        ])
        let diff = FragmentDiff.updateRegular(children: [
            1: .string("b")
        ])
        XCTAssertThrowsError(try current.merge(with: diff)) { error in
            XCTAssertEqual(error as! MergeError, MergeError.addChildToExisting)
        }
    }
    
}
