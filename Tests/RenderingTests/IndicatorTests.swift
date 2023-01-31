//
//  IndicatorTests.swift
//  
//
//  Created by Carson Katri on 1/17/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class IndicatorTests: XCTestCase {
    func testProgressViewValue() throws {
        try assertMatch(#"<progress-view value="0.5" />"#, size: .init(width: 200, height: 200)) {
            ProgressView(value: 0.5)
        }
    }
    
    func testProgressViewTotal() throws {
        try assertMatch(#"<progress-view value="2.5" total="5" />"#, size: .init(width: 200, height: 200)) {
            ProgressView(value: 2.5, total: 5)
        }
    }
}
