//
//  Array+Decodable.swift
//  
//
//  Created by Dylan.Ginsburg on 5/19/23.
//

import Foundation
@testable import LiveViewNative

extension Array where Element: Decodable {
    init(jsonValues: [String]) throws {
        self = try makeJSONDecoder().decode(Self.self, from: Data(
            #"""
            ["\#(jsonValues.joined(separator: "\",\""))"]
            """#.utf8
        ))
    }
}
