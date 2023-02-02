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

    let decoder = JSONDecoder()
    
    private func assertDecodeModifier<T: ViewModifier & Equatable>(_ json: String, expected: T) throws
    where T: Decodable
    {
        let data = json.data(using: .utf8)!
        let decoded = try decoder.decode(T.self, from: data)
        XCTAssertEqual(decoded, expected)
    }
    
    func testDecodeFrame() throws {
        let fixed = """
        {"type": "frame", "width": 100}
        """
        try assertDecodeModifier(fixed, expected: FrameModifier.fixed(width: 100, height: nil, alignment: .center))
        let flexible = """
        {"type": "frame", "min_height": 100, "max_height": 200, "max_width": 300, "alignment": "leading"}
        """
        try assertDecodeModifier(flexible, expected: FrameModifier.flexible(minWidth: nil, idealWidth: nil, maxWidth: 300, minHeight: 100, idealHeight: nil, maxHeight: 200, alignment: .leading))
        let invalid = """
        {"type": "frame", "width": 100, "max_height": 300}
        """
        XCTAssertThrowsError(try decoder.decode(FrameModifier.self, from: invalid.data(using: .utf8)!))
    }
    
    func testDecodeListRowInsets() throws {
        let data = """
        {"type": "list_row_insets", "all": 10}
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
    
    func testDecodePadding() throws {
        let data = """
        {"type": "padding", "top": 10, "leading": 5, "bottom": 10, "trailing": 5}
        """
        try assertDecodeModifier(data, expected: PaddingModifier(insets: EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)))
    }
    
    func testDecodeTint() throws {
        let data = """
        {"type": "tint", "color": "system-pink"}
        """
        try assertDecodeModifier(data, expected: TintModifier(color: .pink))
    }

}
