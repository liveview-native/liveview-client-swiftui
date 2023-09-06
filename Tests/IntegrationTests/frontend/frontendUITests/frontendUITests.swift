//
//  frontendUITests.swift
//  frontendUITests
//
//  Created by Carson.Katri on 9/5/23.
//

import XCTest
@testable import LiveViewNative

final class frontendUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func launch(_ path: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append(path)
        app.launch()
        return app
    }

    func testNavigation() throws {
        let app = launch("navigation")
        
        app.buttons["push_navigate"].tap() // navigate to page 2
        XCTAssertEqual(app.staticTexts.element.label, "Page 2")
        app.navigationBars.element.buttons.element.tap() // go back
        
        app.buttons["redirect"].tap() // redirect to page 2
        XCTAssertEqual(app.staticTexts.element.label, "Page 2")
        app.navigationBars.element.buttons.element.tap() // go back
        
        app.buttons["push_navigate:replace"].tap() // navigate to page 2 (replacing the current page)
        XCTAssertEqual(app.staticTexts.element.label, "Page 2")
        XCTAssertEqual(app.navigationBars.element.buttons.count, 0)
    }
    
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
    
    func testPresentationModifiers() {
        let app = launch("presentation-modifiers")
        
        app.buttons["present"].tap()
        XCTAssert(app.staticTexts["sheet"].exists)
        // Note: `app.sheets` does not query any values. This may be a bug in SwiftUI
        // To dismiss, instead just perform a swipe down on the app.
        app.swipeDown(velocity: .fast)
        XCTAssertFalse(app.staticTexts["sheet"].exists)
    }
}
