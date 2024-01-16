//
//  ShapeStyleTests.swift
//
//
//  Created by Carson Katri on 1/16/24.
//

import XCTest
import SwiftUI
@testable import LiveViewNativeStylesheet
@testable import LiveViewNative

extension XCTestCase {
    func testParserEqual<T>(
        _ ast: String,
        _ value: T
    ) where T: Equatable, T: ParseableModifierValue {
        XCTAssertEqual(
            try T.parser(in: .init()).parse(ast),
            value
        )
    }
    func testParser<T>(
        _ ast: String,
        as t: T.Type = T.self
    ) where T: ParseableModifierValue {
        XCTAssertNoThrow(try T.parser(in: .init()).parse(ast))
    }
}

extension XCTestCase {
    func testParserShapeStyle<T>(
        _ ast: String,
        _ value: T
    ) where T: Equatable, T: ParseableModifierValue {
        testParserEqual(ast, value)
        testParser(ast, as: AnyShapeStyle.self)
    }
}

final class ShapeStyleTests: XCTestCase {
    func testColor() {
        testParserShapeStyle(
            #"{:Color, [], [{:., [], [nil, :sRGB]}, [red: 0.4627, green: 0.8392, blue: 1.0]]}"#,
            Color(.sRGB, red: 0.4627, green: 0.8392, blue: 1.0)
        )
        testParserShapeStyle(
            #"{:., [], [:Color, :pink]}"#,
            Color.pink
        )
        testParserShapeStyle(
            #"{:., [], [nil, :pink]}"#,
            Color.pink
        )
        testParserShapeStyle(
            #"{:., [], [nil, {:., [], [:pink, {:opacity, [], [0.5]}]}]}"#,
            Color.pink.opacity(0.5)
        )
        testParserShapeStyle(
            #"{:., [], [:Color, {:., [], [:pink, {:opacity, [], [0.5]}]}]}"#,
            Color.pink.opacity(0.5)
        )
        testParserShapeStyle(
            #"{:Color, [], [{:., [], [nil, :sRGB]}, [white: 0.5, opacity: 0.5]]}"#,
            Color(.sRGB, white: 0.5, opacity: 0.5)
        )
        testParserShapeStyle(
            #"{:Color, [], [[hue: 1, saturation: 0.5, brightness: 0.25, opacity: 0.75]]}"#,
            Color(hue: 1, saturation: 0.5, brightness: 0.25, opacity: 0.75)
        )
    }
    
    func testGradient() {
        testParserShapeStyle(
            #"{:., [], [:Color, {:., [], [:red, :gradient]}]}"#,
            Color.red.gradient
        )
        testParserShapeStyle(
            #"{:., [], [:Color, {:., [], [:pink, {:., [], [{:opacity, [], [0.5]}, :gradient]}]}]}"#,
            Color.pink.opacity(0.5).gradient
        )
    }
}
