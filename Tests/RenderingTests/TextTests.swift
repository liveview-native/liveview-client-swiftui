//
//  TextTests.swift
//  
//
//  Created by Carson Katri on 1/10/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class TextTests: XCTestCase {
    // MARK: Text
    func testTextSimple() throws {
        try assertMatch("<Text>Hello, world!</Text>") {
            Text("Hello, world!")
        }
    }

    func testTextStyles() throws {
        for style in Font.TextStyle.allCases {
            try assertMatch(#"<Text font="\#(style)">Hello, world!</Text>"#) {
                Text("Hello, world!").font(.system(style, weight: .regular))
            }
        }
    }

    func testTextWeights() throws {
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
            try assertMatch(name: "weight-\(name)", #"<Text font="body" font-weight="\#(name)">Hello, world!</Text>"#) {
                Text("Hello, world!").font(.system(.body, weight: weight))
            }
        }
    }

    func testTextColor() throws {
        for color in [Color.primary, Color.red, Color.blue] {
            try assertMatch(#"<Text color="system-\#(color)">Hello, world!</Text>"#) {
                Text("Hello, world!").foregroundColor(color)
            }
        }
    }
    
    func testTextNesting() throws {
        try assertMatch(#"""
<Text>
    <Image system-name="person.crop.circle.fill" />
    <Text verbatim=" " />
    <Text color="system-secondary">John Doe</Text>
    <Text verbatim="
" />
    Plain text<Text verbatim=" " />
    <Link destination="https://apple.com">visit apple.com</Link>
    <Text>. More plain text</Text>
</Text>
"""#) {
            Text("""
\(Image(systemName: "person.crop.circle.fill")) \(Text("John Doe").foregroundColor(.secondary))
Plain text [visit apple.com](https://apple.com). More plain text
""")
        }
    }
    
    func testTextMarkdown() throws {
        try assertMatch(#"""
<Text markdown="*Hello, world!*
This is some markdown text [click me](apple.com)" />
"""#) {
            Text("""
*Hello, world!*
This is some markdown text [click me](apple.com)
""")
        }
    }
    
    func testTextDate() throws {
        try assertMatch(#"<Text date="2023-01-17" date-style="date" />"#) {
            Text(Date(timeIntervalSince1970: 1673931600.0), style: .date)
        }
        for style in [(Text.DateStyle.time, "time"), (.date, "date"), (.relative, "relative"), (.offset, "offset"), (.timer, "timer")] {
            try assertMatch(#"<Text date="2023-01-17T14:55:01.326Z" date-style="\#(style.1)" />"#) {
                Text(Date(timeIntervalSince1970: 1673967301.325973), style: style.0)
            }
        }
    }
    
    func testTextFormat() throws {
        try assertMatch(#"<Text format="date-time" value="0001-01-01T00:00:00.000Z" />"#) {
            Text(Date.distantPast, format: .dateTime)
        }
        try assertMatch(#"<Text format="url">apple.com</Text>"#) {
            Text(URL(string: "apple.com")!, format: .url)
        }
        try assertMatch(#"<Text format="iso8601" value="0001-01-01T00:00:00.000Z" />"#) {
            Text(Date.distantPast, format: .iso8601)
        }
        try assertMatch(#"<Text format="number" value="0.42" />"#) {
            Text(0.42, format: .number)
        }
        try assertMatch(#"<Text format="percent" value="0.42" />"#) {
            Text(0.42, format: .percent)
        }
        try assertMatch(#"<Text format="currency" currency-code="mxn" value="42" />"#) {
            Text(42, format: .currency(code: "mxn"))
        }
        try assertMatch(#"<Text format="name" name-style="short">John Doe</Text>"#) {
            Text(try! PersonNameComponents("John Doe", strategy: .name), format: .name(style: .short))
        }
    }
    
    // MARK: TextField
    func testTextFieldSimple() throws {
        try assertMatch(#"<TextField>Type here</TextField>"#) {
            TextField("Type here", text: .constant(""))
        }
        try assertMatch(#"<SecureField>Password</SecureField>"#) {
            SecureField("Password", text: .constant(""))
        }
    }
    func testTextFieldPrompt() throws {
        try assertMatch(#"<TextField prompt="Prompt">Placeholder</TextField>"#) {
            TextField("Placeholder", text: .constant(""), prompt: Text("Prompt"))
        }
        try assertMatch(#"<SecureField prompt="Prompt">Placeholder</SecureField>"#) {
            SecureField("Placeholder", text: .constant(""), prompt: Text("Prompt"))
        }
    }
    
    // MARK: Label
    func testLabelSimple() throws {
        try assertMatch(#"<Label system-image="bolt.fill">Lightning<Label>"#) {
            Label("Lightning", systemImage: "bolt.fill")
        }
    }
    
    func testLabelSlots() throws {
        try assertMatch(
            #"""
            <Label>
                <Label:icon><Image system-name="bolt.fill" /></Label:icon>
                <Label:title><Text>Lightning</Text></Label:title>
            <Label>
            """#
        ) {
            Label {
                Text("Lightning")
            } icon: {
                Image(systemName: "bolt.fill")
            }
        }
    }
}
