//
//  File.swift
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
        try assertMatch(#"<lvn-link destination="https://apple.com">Hello, world!</lvn-link>"#) {
            Link("Hello, world!", destination: URL(string: "https://apple.com")!)
        }
    }
    
    func testComplexBody() throws {
        try assertMatch(#"""
<lvn-link destination="https://apple.com">
    <hstack>
        <image system-name="link" />
        <text>Click the link</text>
    </hstack>
</lvn-link>
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
