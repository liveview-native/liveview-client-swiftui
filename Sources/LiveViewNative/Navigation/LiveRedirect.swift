//
//  LiveRedirect.swift
//  
//
//  Created by Carson.Katri on 1/6/23.
//

import Foundation

struct LiveRedirect {
    let kind: Kind
    let to: URL
    
    enum Kind: String {
        case push
        case replace
    }
    
    init?(from payload: Payload, relativeTo rootURL: URL) {
        guard let kind = (payload["kind"] as? String).flatMap(Kind.init),
              let to = (payload["to"] as? String).flatMap({ URL.init(string: $0, relativeTo: rootURL) })
        else { return nil }
        self.kind = kind
        self.to = to
    }
}
