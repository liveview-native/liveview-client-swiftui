import XCTest
import SwiftUI
@testable import LiveViewNativeStylesheet
@testable import LiveViewNative

final class LiveViewNativeStylesheetTests: XCTestCase {
    func testAlignment() throws {
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :topLeading]}"), Alignment.topLeading)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :top]}"), Alignment.top)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :centerFirstTextBaseline]}"), Alignment.centerFirstTextBaseline)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :centerLastTextBaseline]}"), Alignment.centerLastTextBaseline)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :leadingFirstTextBaseline]}"), Alignment.leadingFirstTextBaseline)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :leadingLastTextBaseline]}"), Alignment.leadingLastTextBaseline)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :trailingFirstTextBaseline]}"), Alignment.trailingFirstTextBaseline)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :trailingLastTextBaseline]}"), Alignment.trailingLastTextBaseline)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :topLeading]}"), Alignment.topLeading)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :topTrailing]}"), Alignment.topTrailing)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :bottomLeading]}"), Alignment.bottomLeading)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :bottomTrailing]}"), Alignment.bottomTrailing)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :top]}"), Alignment.top)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :bottom]}"), Alignment.bottom)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :center]}"), Alignment.center)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :leading]}"), Alignment.leading)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :trailing]}"), Alignment.trailing)
    }
    
    func testEvent() throws {
        XCTAssertNoThrow(try Event.parser(in: .init()).parse(#"{:__event__, [], ["search"]}"#))
        XCTAssertNoThrow(try Event.parser(in: .init()).parse(#"{:__event__, [], ["search", []]}"#))
    }
}
