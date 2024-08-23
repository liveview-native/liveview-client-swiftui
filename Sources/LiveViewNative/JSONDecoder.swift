//
//  JSONDecoder.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/28/23.
//

import Foundation

func makeJSONDecoder() -> JSONDecoder {
    decoder
}

fileprivate let decoder: JSONDecoder = {
    return Foundation.JSONDecoder()
}()
