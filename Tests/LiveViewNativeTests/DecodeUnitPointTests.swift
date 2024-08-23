//
//  DecodeUnitPointTests.swift
//  
//
//  Created by Carson Katri on 3/15/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative
@testable import LiveViewNativeCore

final class DecodeUnitPointTests: XCTestCase {
    func testLiteral() throws {
        XCTAssertEqual(try UnitPoint(from: "zero"), .zero)
        XCTAssertEqual(try UnitPoint(from: "center"), .center)
        XCTAssertEqual(try UnitPoint(from: "leading"), .leading)
        XCTAssertEqual(try UnitPoint(from: "trailing"), .trailing)
        XCTAssertEqual(try UnitPoint(from: "top"), .top)
        XCTAssertEqual(try UnitPoint(from: "bottom"), .bottom)
        XCTAssertEqual(try UnitPoint(from: "topLeading"), .topLeading)
        XCTAssertEqual(try UnitPoint(from: "topTrailing"), .topTrailing)
        XCTAssertEqual(try UnitPoint(from: "bottomLeading"), .bottomLeading)
        XCTAssertEqual(try UnitPoint(from: "bottomTrailing"), .bottomTrailing)
    }
    
    func testInteger() throws {
        XCTAssertEqual(try UnitPoint(from: "0,0"), .init(x: 0, y: 0))
        XCTAssertEqual(try UnitPoint(from: "1,0"), .init(x: 1, y: 0))
        XCTAssertEqual(try UnitPoint(from: "-1,2"), .init(x: -1, y: 2))
        XCTAssertEqual(try UnitPoint(from: "-1,-20"), .init(x: -1, y: -20))
    }
    
    func testDecimal() throws {
        XCTAssertEqual(try UnitPoint(from: "0.0,0"), .init(x: 0, y: 0))
        XCTAssertEqual(try UnitPoint(from: "1,1.00"), .init(x: 1, y: 1))
        XCTAssertEqual(try UnitPoint(from: "-11.255,20.3"), .init(x: -11.255, y: 20.3))
        XCTAssertEqual(try UnitPoint(from: "-1.1,-2.3"), .init(x: -1.1, y: -2.3))
    }
}
