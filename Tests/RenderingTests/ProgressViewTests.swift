//
//  ProgressViewTests.swift
//  
//
//  Created by Carson Katri on 1/17/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class ProgressViewTests: XCTestCase {
    func testValue() throws {
        try assertMatch(#"<progressview value="0.5" />"#) {
            ProgressView(value: 0.5)
        }
    }
    
    func testTotal() throws {
        try assertMatch(#"<progressview value="2.5" total="5" />"#) {
            ProgressView(value: 0.5, total: 5)
        }
    }
}
