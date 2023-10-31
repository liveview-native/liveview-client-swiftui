//
//  DecodeModifiersTest.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 1/4/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

final class DecodeModifiersTest: XCTestCase {
    func testStylesheet() throws {
//        let content = "%{\"align-center\" => [{:frame, [file: \"\", line: 1, module: \"\"], [[maxWidth: {:., [file: \"\", line: 1, module: \"\"], [nil, :infinity]}, alignment: {:., [file: \"\", line: 1, module: \"\"], [nil, :center]}]]}]}"
//        
//        let stylesheet = try Stylesheet<EmptyRegistry>(from: content, in: .init())
//        print(stylesheet)
        
        let viewReference = ":\"step-bg\""
        
        print(try ViewReference.parser(in: .init()))
    }
}
