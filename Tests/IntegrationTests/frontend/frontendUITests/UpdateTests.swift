//
//  UpdateTests.swift
//  frontendUITests
//
//  Created by Carson.Katri on 9/6/23.
//

import XCTest

final class UpdateTests: LiveViewNativeTestCase {
    func testCounter() {
        let app = launch("counter")
        
        XCTAssert(app.staticTexts["0"].exists)
        app.buttons["increment"].tap()
        XCTAssert(app.staticTexts["1"].exists)
        app.buttons["increment"].tap()
        app.buttons["increment"].tap()
        app.buttons["increment"].tap()
        XCTAssert(app.staticTexts["4"].exists)
        
        app.buttons["decrement"].tap()
        XCTAssert(app.staticTexts["3"].exists)
        app.buttons["decrement"].tap()
        app.buttons["decrement"].tap()
        XCTAssert(app.staticTexts["1"].exists)
        
        app.buttons["increment"].tap()
        app.buttons["decrement"].tap()
        XCTAssert(app.staticTexts["1"].exists)
    }
}
