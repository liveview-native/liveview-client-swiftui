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
            try assertMatch(name: "weight-\(name)", #"<text font="body" font-weight="\#(name)">Hello, world!</text>"#) {
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
    
    func testNesting() throws {
        try assertMatch(#"""
<text>
    <image system-name="person.crop.circle.fill" />
    <text verbatim=" " />
    <text color="system-secondary">John Doe</text>
    <text verbatim="
" />
    Plain text<text verbatim=" " />
    <lvn-link destination="https://apple.com">visit apple.com</lvn-link>
    <text>. More plain text</text>
</text>
"""#) {
            Text("""
\(Image(systemName: "person.crop.circle.fill")) \(Text("John Doe").foregroundColor(.secondary))
Plain text [visit apple.com](https://apple.com). More plain text
""")
        }
    }
    
    func testMarkdown() throws {
        try assertMatch(#"""
<text markdown="*Hello, world!*
This is some markdown text [click me](apple.com)" />
"""#) {
            Text("""
*Hello, world!*
This is some markdown text [click me](apple.com)
""")
        }
    }
    
    func testDate() throws {
        try assertMatch(#"<text date="2023-01-17" date-style="date" />"#) {
            Text(Date(timeIntervalSince1970: 1673931600.0), style: .date)
        }
        for style in [(Text.DateStyle.time, "time"), (.date, "date"), (.relative, "relative"), (.offset, "offset"), (.timer, "timer")] {
            try assertMatch(#"<text date="2023-01-17T14:55:01.326Z" date-style="\#(style.1)" />"#) {
                Text(Date(timeIntervalSince1970: 1673967301.325973), style: style.0)
            }
        }
    }
    
    func testFormat() throws {
        try assertMatch(#"<text format="date-time" value="2023-01-17" />"#) {
            Text(Date(timeIntervalSince1970: 1673931600.0), format: .dateTime)
        }
        try assertMatch(#"<text format="url">apple.com</text>"#) {
            Text(URL(string: "apple.com")!, format: .url)
        }
        try assertMatch(#"<text format="iso8601" value="2023-01-17T14:55:01.326Z" />"#) {
            Text(Date(timeIntervalSince1970: 1673967301.325973), format: .iso8601)
        }
        try assertMatch(#"<text format="number" value="0.42" />"#) {
            Text(0.42, format: .number)
        }
        try assertMatch(#"<text format="percent" value="0.42" />"#) {
            Text(0.42, format: .percent)
        }
        try assertMatch(#"<text format="currency" currency-code="mxn" value="42" />"#) {
            Text(42, format: .currency(code: "mxn"))
        }
        try assertMatch(#"<text format="name" name-style="short">John Doe</text>"#) {
            Text(try! PersonNameComponents("John Doe", strategy: .name), format: .name(style: .short))
        }
    }
}
