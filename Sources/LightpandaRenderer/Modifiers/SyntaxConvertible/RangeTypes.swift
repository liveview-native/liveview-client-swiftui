import SwiftSyntax
import SwiftUI

// MARK: - PartialRangeFrom<Int>
// Supports: 5... (5 or more)
extension PartialRangeFrom<Int>: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Look for PostfixOperatorExprSyntax with "..." operator
        // e.g., 5...
        if let postfix = syntax.as(PostfixOperatorExprSyntax.self),
           postfix.operator.text == "...",
           let lowerBound = Int(syntax: postfix.expression) {
            self = lowerBound...
            return
        }
        return nil
    }
}

// MARK: - PartialRangeThrough<Int>
// Supports: ...5 (up to and including 5)
extension PartialRangeThrough<Int>: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Look for PrefixOperatorExprSyntax with "..." operator
        // e.g., ...5
        if let prefix = syntax.as(PrefixOperatorExprSyntax.self),
           prefix.operator.text == "...",
           let upperBound = Int(syntax: prefix.expression) {
            self = ...upperBound
            return
        }
        return nil
    }
}

// MARK: - ClosedRange<Int>
// Supports: 2...5 (2 to 5 inclusive)
extension ClosedRange<Int>: SyntaxConvertible where Bound == Int {
    public init?(syntax: some SyntaxProtocol) {
        // Look for InfixOperatorExprSyntax or SequenceExprSyntax with "..." operator
        // e.g., 2...5
        if let sequence = syntax.as(SequenceExprSyntax.self) {
            let elements = Array(sequence.elements)
            if elements.count == 3,
               let lowerBound = Int(syntax: elements[0]),
               let op = elements[1].as(BinaryOperatorExprSyntax.self),
               op.operator.text == "...",
               let upperBound = Int(syntax: elements[2]) {
                self = lowerBound...upperBound
                return
            }
        }
        return nil
    }
}
