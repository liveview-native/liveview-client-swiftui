//
//  LiveConnectionError.swift
//  
//
//  Created by Carson Katri on 1/6/23.
//

import Foundation
import SwiftPhoenixClient

public enum LiveConnectionError: Error {
    case initialFetchError(Error)
    case initialFetchUnexpectedResponse(URLResponse)
    /// An error encountered when parsing the initial HTML.
    case initialParseError
    case socketError(Error)
    case joinError(Message)
    case eventError(Message)
    
    var localizedDescription: String {
        switch self {
        case .initialFetchError(let error):
            return "initialFetchError(\(error))"
        case .initialFetchUnexpectedResponse(let resp):
            return "initialFetchUnexpectedResponse(\(resp))"
        case .initialParseError:
            return "initialParseError"
        case .socketError(let error):
            return "socketError(\(error))"
        case .joinError(let message):
            return "joinError(\(message.payload))"
        case .eventError(let message):
            return "eventError(\(message.payload))"
        }
    }
}
