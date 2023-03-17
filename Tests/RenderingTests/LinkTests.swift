//
//  LinkTests.swift
//  
//
//  Created by Carson Katri on 1/17/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class LinkTests: XCTestCase {
    func testSimple() throws {
        try assertMatch(#"<Link destination="https://apple.com">Hello, world!</Link>"#) {
            Link("Hello, world!", destination: URL(string: "https://apple.com")!)
        }
    }
    
    func testComplexBody() throws {
        try assertMatch(#"""
<Link destination="https://apple.com">
    <HStack>
        <Image system-name="link" />
        <Text>Click the link</Text>
    </HStack>
</Link>
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
