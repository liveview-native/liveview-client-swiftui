//
//  LifecycleTests.swift
//  frontendUITests
//
//  Created by Carson.Katri on 9/6/23.
//

import XCTest

final class LifecycleTests: LiveViewNativeTestCase {
    func testNavigation() throws {
        let app = launch("navigation")
        
        app.buttons["push_navigate"].tap() // navigate to page 2
        XCTAssertEqual(app.staticTexts.element.label, "Page 2")
        app.navigationBars.element.buttons.element.tap() // go back
        
        app.buttons["redirect"].tap() // redirect to page 2
        XCTAssertEqual(app.staticTexts.element.label, "Page 2")
        app.navigationBars.element.buttons.element.tap() // go back
        
        // FIXME: This form of navigation is not working.
        app.buttons["push_navigate:replace"].tap() // navigate to page 2 (replacing the current page)
        XCTAssertEqual(app.staticTexts.element.label, "Page 2")
        XCTAssertEqual(app.navigationBars.element.buttons.count, 0)
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
