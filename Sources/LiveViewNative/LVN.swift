//
//  LVN.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/28/23.
//

import Foundation

struct LVN {
    static func JSONDecoder() -> JSONDecoder {
        let decoder = Foundation.JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
