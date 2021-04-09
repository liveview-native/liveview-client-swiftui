//
//  DiffTests.swift
//  
//
//  Created by Brian Cardarella on 3/30/21.
//

import XCTest
import SwiftSoup

@testable import PhoenixLiveViewNative

final class DiffTests: XCTestCase {
    func testToIODataWithSubtreesChain()throws {
        let sample: Payload = [
            "0": ["d": [["1", 1], ["2", 2], ["3", 3]], "s": ["\n", ":", ""]],
            "c": [
                "1": ["0": ["0": "index_1", "s": ["\nIF ", ""]], "s": ["", ""]],
                "2": ["0": ["0": "index_2", "s": ["\nELSE ", ""]], "s": 1],
                "3": ["0": ["0": "index_3"], "s": 2]
            ],
            "s": ["<div>", "\n</div>\n"]
          ]

        
        let actual = try renderToString(sample)
                
        let expected = "<div>\n1:\nIF index_1\n2:\nELSE index_2\n3:\nELSE index_3\n</div>\n"
        
        XCTAssertEqual(expected, actual)
    }
    

// The following two tests are smoke tests for complex private function testing.
// The corresponding private functions need to be made public to test them.
//
//    func testResolve()throws {
//        let cid = 2
//        let c: Payload = [
//            1: [0: [0: "index_1", "s": ["\nIF ", ""]], "s": ["", ""]],
//            2: [0: [0: "index_2", "s": ["\nELSE ", ""]], "s": 1],
//            3: [0: [0: "index_3"], "s": 2]
//          ]
//
//        let actual = try Diff.resolveComponentsXrefs(cid, c)
//
//        let expected: Payload = [
//            1: [0: [0: "index_1", "s": ["\nIF ", ""]], "s": ["", ""]],
//            2: [0: [0: "index_2", "s": ["\nELSE ", ""]], "s": ["", ""]],
//            3: [0: [0: "index_3"], "s": 2]
//          ]
//
//        compareNestedDictionaries(expected, actual)
//    }
//
//    func testDeepMerge()throws {
//        let left: Payload = [0: [0: "index_1", "s": ["\nIF ", ""]], "s": ["", ""]]
//        let right: Payload = [0: [0: "index_2", "s": ["\nELSE ", ""]]]
//
//        let expected: Payload = [0: [0: "index_2", "s": ["\nELSE ", ""]], "s": ["", ""]]
//
//        let actual = try Diff.deepMerge(left, right)
//
//        compareNestedDictionaries(expected, actual)
//    }
//
//    func testDataToString()throws {
//        let data = Data("1234".utf8)
//
//        let actual: String = Diff.dataToString(data)
//
//        XCTAssertEqual("1234", actual)
//    }

    func testDataToString() {
        let sample = Data("foobar".utf8)
        let actual = Diff.dataToString(sample)
        
        XCTAssertEqual("foobar", actual)
    }
        
    static var allTests = [
        ("testToIODataWithSubtreesChain", testToIODataWithSubtreesChain)
    ]
    
    private func renderToString(_ diff: Payload)throws -> String {
        return Diff.dataToString(try Diff.toData(diff))
    }
    
    private func compareNestedDictionaries(_ expected: Payload, _ actual: Payload) -> Void {
        if expected.count != actual.count {
            XCTFail("The two objects are not equal")
            return
        }
        
        for (key, value) in expected {
            let expectedValue = value
            let actualValue = actual[key]

            // This is terrible but it works and it only exists in the tests soooo... ¯\_(ツ)_/¯
            if let expectedDict = expectedValue as? Payload, let actualDict = actualValue as? Payload {
                compareNestedDictionaries(expectedDict, actualDict)
                continue
            } else if let expectedStringArray = expectedValue as? Array<String>, let actualStringArray = actualValue as? Array<String> {
                XCTAssertEqual(expectedStringArray, actualStringArray)
            } else if let expectedIntArray = expectedValue as? Array<Int>, let actualIntArray = actualValue as? Array<Int> {
                XCTAssertEqual(expectedIntArray, actualIntArray)
            } else if let expectedString = expectedValue as? String, let actualString = actualValue as? String {
                XCTAssertEqual(expectedString, actualString)
            } else if let expectedInt = expectedValue as? Int, let actualInt = actualValue as? Int {
                XCTAssertEqual(expectedInt, actualInt)
            } else {
                XCTFail()
            }
        }
    }
}
