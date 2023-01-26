//
//  ImageTests.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class ImageTests: XCTestCase {
    func testSystemImage() throws {
        try assertMatch(
            #"""
            <image system-name="person.crop.circle.fill" />
            """#
        ) {
            Image(systemName: "person.crop.circle.fill")
        }
    }
}
