//
//  JSONDecoder.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/28/23.
//

import Foundation

func makeJSONDecoder() -> JSONDecoder {
    snakeCaseDecoder
}

fileprivate let snakeCaseDecoder: JSONDecoder = {
    let decoder = Foundation.JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

extension Array where Element: Decodable {
    init(jsonValues: [String]) throws {
        self = try makeJSONDecoder().decode(Self.self, from: Data(
            #"""
            ["\#(jsonValues.joined(separator: "\",\""))"]
            """#.utf8
        ))
    }
}
