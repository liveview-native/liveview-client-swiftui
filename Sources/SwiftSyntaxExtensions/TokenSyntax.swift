//
//  TokenSyntax.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import SwiftSyntax

public extension TokenSyntax {
    /// The backtick escaped name of this token.
    var escaped: TokenSyntax {
        .identifier("`\(self.text)`")
    }
    
    /// Checks if this token represents any type of operator (`+`, `+=`, `*`, etc.).
    var isOperatorToken: Bool {
        switch self.tokenKind {
        case .binaryOperator:
            return true
        case .prefixOperator:
            return true
        case .postfixOperator:
            return true
        default:
            return false
        }
    }
}
