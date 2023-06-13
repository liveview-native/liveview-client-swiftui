//
//  JSONDecoder.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/28/23.
//

import Foundation

@_spi(LiveViewNative) public func makeJSONDecoder() -> JSONDecoder {
    snakeCaseDecoder
}

fileprivate let snakeCaseDecoder: JSONDecoder = {
    let decoder = Foundation.JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()
