//
//  frontendUITests.swift
//  frontendUITests
//
//  Created by Carson.Katri on 9/5/23.
//

import XCTest

class LiveViewNativeTestCase: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func launch(_ path: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append(path)
        app.launch()
        return app
    }
}
