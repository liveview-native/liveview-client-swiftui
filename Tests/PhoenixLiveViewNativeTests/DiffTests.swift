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
        let sample: [AnyHashable:Any] = [
            0: ["d": [["1", 1], ["2", 2], ["3", 3]], "s": ["\n", ":", ""]],
            "c": [
                1: [0: [0: "index_1", "s": ["\nIF ", ""]], "s": ["", ""]],
                2: [0: [0: "index_2", "s": ["\nELSE ", ""]], "s": 1],
                3: [0: [0: "index_3"], "s": 2]
            ],
            "s": ["<div>", "\n</div>\n"]
          ]
        
        let expected = """
        <div>
        1:
        IF index_1
        2:
        ELSE index_2
        3:
        ELSE index_3
        </div>
        """
    }
    
    func testDataToString()throws {
        let data = Data("1234".utf8)
        
        let actual: String = try Diff.dataToString(data)
        
        XCTAssertEqual("1234", actual)
    }

        
    static var allTests = [
        ("testToIODataWithSubtreesChain", testToIODataWithSubtreesChain)
    ]
    
//    private func renderedToBinary(_ tree: [AnyHashable:Any]) {
//        return DOM.
//    }
}
