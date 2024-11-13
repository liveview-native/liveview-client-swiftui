//
//  FormModelTests.swift
//  
//
//  Created by Adam Woods on 9/7/2024.
//

import XCTest
import LiveViewNativeCore
@_spi(LiveForm) @testable import LiveViewNative

@MainActor
class FormModelTests: XCTestCase {
    func testFormChangeEvent() async throws {
        let expectation = XCTestExpectation(description: "Send a form change event.")
        
        @Sendable
        @MainActor
        func pushEvent(type: String, event: String, value: Any, target: Int? = nil) async throws -> [String:Any]? {
            XCTAssertEqual(type, "form")
            XCTAssertEqual(event, "validate")
            
            let expectedQuery = URLComponents(string: "http://localhost/?b=2&c=3&a=1&_target=a")?.queryItems?.sorted(by: {$0.name < $1.name})
            let actualQuery = URLComponents(string: "http://localhost/?\(value as! String)")?.queryItems?.sorted(by: {$0.name < $1.name})
            XCTAssertEqual(expectedQuery, actualQuery)
            XCTAssertNil(target)

            expectation.fulfill()
            
            return nil
        }
        
        let formModel = FormModel(elementID: "test-form")
        formModel.setInitialValue("1", forName: "a")
        formModel.setInitialValue("2", forName: "b")
        formModel.setInitialValue("3", forName: "c")
        formModel.pushEventImpl = pushEvent
        
        // Associate the formModel with a form
        let document = try LiveViewNativeCore.Document.parse("""
            <Form phx-change="validate"></Form>
        """)
        let element = document[document.root()].children().first?.asElement()
        formModel.updateFromElement(element!) { }
        
        // Emulate sending a change event from the form itself (no event)
        try await formModel.sendChangeEvent("2", for: "a", event: nil)
        
        await fulfillment(of: [expectation])
    }
}
