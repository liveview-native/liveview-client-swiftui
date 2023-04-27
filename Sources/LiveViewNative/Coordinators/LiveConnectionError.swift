//
//  LiveConnectionError.swift
//  
//
//  Created by Carson Katri on 1/6/23.
//

import Foundation
import SwiftPhoenixClient

/// An error that occurred when connecting to a live view.
public enum LiveConnectionError: Error, LocalizedError {
    case initialFetchError(Error)
    case initialFetchUnexpectedResponse(URLResponse)
    /// An error encountered when parsing the initial HTML.
    case initialParseError(missingOrInvalid: InitialParseComponent)
    case socketError(Error)
    case joinError(Message)
    case eventError(Message)
    
    public var errorDescription: String? {
        switch self {
        case .initialFetchError(let error):
            return "initialFetchError(\(error))"
        case .initialFetchUnexpectedResponse(let resp):
            return "initialFetchUnexpectedResponse(\(resp))"
        case .initialParseError(let missingOrInvalid):
            return "Initial parse error: missing or invalid \(missingOrInvalid)"
        case .socketError(let error):
            return "socketError(\(error))"
        case .joinError(let message):
            return "joinError(\(message.payload))"
        case .eventError(let message):
            return "eventError(\(message.payload))"
        }
    }
    
    public enum InitialParseComponent: CustomStringConvertible {
        case document
        case csrfToken
        case phxMain
        
        public var description: String {
            switch self {
            case .document:
                return "document"
            case .csrfToken:
                return #"<meta name="csrf-token">"#
            case .phxMain:
                return #"<div data-phx-main="...">"#
            }
        }
    }
}
