//
//  TextTests.swift
//  
//
//  Created by Carson Katri on 1/10/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class TextTests: XCTestCase {
    func testSimple() throws {
        try assertMatch("<text>Hello, world!</text>") {
            Text("Hello, world!")
        }
    }
    func testStyles() throws {
        for style in Font.TextStyle.allCases {
            try assertMatch(#"<text font="\#(style)">Hello, world!</text>"#) {
                Text("Hello, world!").font(.system(style, weight: .regular))
            }
        }
    }
    func testWeights() throws {
        let allWeights: [String:Font.Weight] = [
            "ultraLight": .ultraLight,
            "thin": .thin,
            "light": .light,
            "regular": .regular,
            "medium": .medium,
            "semibold": .semibold,
            "bold": .bold,
            "heavy": .heavy,
            "black": .black,
        ]
        for (name, weight) in allWeights {
            try assertMatch(#"<text font="body" font-weight="\#(name)">Hello, world!</text>"#) {
                Text("Hello, world!").font(.system(.body, weight: weight))
            }
        }
    }
    func testColor() throws {
        for color in [Color.primary, Color.red, Color.blue] {
            try assertMatch(#"<text color="system-\#(color)">Hello, world!</text>"#) {
                Text("Hello, world!").foregroundColor(color)
            }
        }
    }
}
