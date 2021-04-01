//
//  File.swift
//  
//
//  Created by Brian Cardarella on 3/30/21.
//

import SwiftSoup
import Foundation

class Diff {
    static let STATIC_FRAGMENT: AnyHashable = "s"
    static let COMPONENT_FRAGMENT: AnyHashable = "c"
    static let DYNAMICS: AnyHashable = "d"
    static let EVENTS: AnyHashable = "e"
    static let REPLY: AnyHashable = "r"
    static let TITLE: AnyHashable = "t"
    
    static func elementsToData(_ rendered: Elements, _ closure: (_ cid: Int, _ contents: Data)throws -> String )throws -> Data {
        return Data()
    }
    
    static func dataToString(_ data: Data)throws -> String {
        return String(decoding: data, as: UTF8.self)
    }
}
