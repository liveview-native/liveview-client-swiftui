//
//  LinkTests.swift
//  
//
//  Created by Carson Katri on 1/17/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class LinkTests: XCTestCase {
    func testSimple() throws {
        try assertMatch(#"<link destination="https://apple.com">Hello, world!</link>"#) {
            Link("Hello, world!", destination: URL(string: "https://apple.com")!)
        }
    }
    
    func testComplexBody() throws {
        try assertMatch(#"""
<link destination="https://apple.com">
    <h-stack>
        <image system-name="link" />
        <text>Click the link</text>
    </h-stack>
</link>
"""#) {
            Link(destination: URL(string: "https://apple.com")!) {
                HStack {
                    Image(systemName: "link")
                    Text("Click the link")
                }
            }
        }
    }
}
