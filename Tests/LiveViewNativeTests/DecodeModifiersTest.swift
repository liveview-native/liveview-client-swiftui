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

    let decoder = makeJSONDecoder()
    
    private func assertDecodeModifier<T: ViewModifier & Equatable>(_ json: String, expected: T) throws
    where T: Decodable
    {
        let data = json.data(using: .utf8)!
        let decoded = try decoder.decode(T.self, from: data)
        XCTAssertEqual(decoded, expected)
    }
    
    func testDecodeListRowInsets() throws {
        let data = """
        {"type": "list_row_insets", "insets": 10}
        """
        try assertDecodeModifier(data, expected: ListRowInsetsModifier(insets: EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)))
    }
    
    func testDecodeListRowSeparator() throws {
        let data = """
        {"type": "list_row_separator", "edges": "bottom", "visibility": "hidden"}
        """
        try assertDecodeModifier(data, expected: ListRowSeparatorModifier(visibility: .hidden, edges: .bottom))
    }
    
    func testDecodeNavigationTitle() throws {
        let data = """
        {"type": "navigation_title", "title": "hello"}
        """
        try assertDecodeModifier(data, expected: NavigationTitleModifier(title: "hello"))
    }
    
    func testDecodeTint() throws {
        let data = """
        {"type": "tint", "color": {"string": "system-pink", "rgb_color_space": null}}
        """
        try assertDecodeModifier(data, expected: TintModifier(color: .pink))
    }

}
