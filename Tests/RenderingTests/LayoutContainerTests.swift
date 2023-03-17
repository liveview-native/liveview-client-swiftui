//
//  LayoutContainerTests.swift
//
//
//  Created by Carson Katri on 2/21/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class LayoutContainerTests: XCTestCase {
    // MARK: ViewThatFits
    
    func testViewThatFits() throws {
        try assertMatch(
            #"""
            <ViewThatFits axes="horizontal">
                <Text>Long post content, takes up most of the space</Text>
                <Text>Shorter version</Text>
            </ViewThatFits>
            """#,
            size: .init(width: 300, height: 100)
        ) {
            ViewThatFits(in: .horizontal) {
                Text("Long post content, takes up most of the space")
                Text("Shorter version")
            }
        }
        try assertMatch(
            #"""
            <ViewThatFits>
                <Text>Long post content, takes up most of the space</Text>
                <Text>Shorter version</Text>
            </ViewThatFits>
            """#,
            size: .init(width: 500, height: 100)
        ) {
            ViewThatFits {
                Text("Long post content, takes up most of the space")
                Text("Shorter version")
            }
        }
    }
}
