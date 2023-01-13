//
//  Element.swift
// LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftSoup

extension Node {
    public func attrIfPresent(_ attr: String) -> String? {
        precondition(!attr.isEmpty)
        // try! is safe here, attr only throws if the param is empty
        return hasAttr(attr) ? try! self.attr(attr) : nil
    }
}

extension Element {
    func buildPhxValuePayload() -> Payload {
        guard let attributes = getAttributes() else {
            return [:]
        }
        let prefix = "phx-value-"
        return attributes
            .filter {
                $0.getKey().starts(with: prefix)
            }.reduce(into: [:]) { partialResult, attr in
                partialResult[String(attr.getKey().dropFirst(prefix.count))] = attr.getValue()
            }
    }
}
