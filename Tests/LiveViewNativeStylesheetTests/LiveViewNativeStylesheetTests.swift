import XCTest
import SwiftUI
@testable import LiveViewNativeStylesheet
@testable import LiveViewNative

final class LiveViewNativeStylesheetTests: XCTestCase {
    func testAlignment() throws {
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :topLeading]}"), Alignment.topLeading)
        XCTAssertEqual(try Alignment.parser(in: .init()).parse("{:., [], [nil, :top]}"), Alignment.top)
    }
}
