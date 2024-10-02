//
//  ASTDecodable.swift
//  LiveViewNative
//
//  Created by Carson Katri on 9/24/24.
//

import SwiftUI
import Foundation

/// A macro that can decode a type from a JSON representation of an AST node.
///
/// - Parameter identifier The name of the node, matched from the first element in a node tuple.
@attached(extension, conformances: Swift.Decodable, names: named(init(from:)))
public macro ASTDecodable(_ identifier: StaticString) = #externalMacro(module: "LiveViewNativeStylesheetMacros", type: "ASTDecodable")

public struct MultipleFailures: Error {
    let errors: [any Error]
    let annotations: Annotations
    
    init(_ errors: [any Error], annotations: Annotations) {
        self.errors = errors
        self.annotations = annotations
    }
}
