import SwiftSyntax
import SwiftUI

public protocol SyntaxConvertible {
    init?(syntax: some SyntaxProtocol)
}

extension FunctionCallExprSyntax {
    func argument(named name: String) -> LabeledExprSyntax? {
        return arguments.first(where: { $0.label?.text == name })
    }
    
    func argument<T: SyntaxConvertible>(named name: String) -> T? {
        guard let arg = arguments.first(where: { $0.label?.text == name }) else {
            return nil
        }
        return T(syntax: arg.expression)
    }
    
    func argument<T: SyntaxConvertible>(named name: String, default defaultValue: T) -> T {
        guard let arg = arguments.first(where: { $0.label?.text == name }) else {
            return defaultValue
        }
        return T(syntax: arg.expression) ?? defaultValue
    }
}

extension LabeledExprListSyntax {
    subscript(index: Int) -> LabeledExprSyntax {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}

extension Optional: SyntaxConvertible where Wrapped: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if syntax.is(NilLiteralExprSyntax.self) {
            self = .none
        } else if let wrapped = Wrapped.init(syntax: syntax) {
            self = .some(wrapped)
        } else {
            return nil
        }
    }
}

extension Int: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle negative numbers: -10 is parsed as PrefixOperatorExpr("-", IntegerLiteralExpr)
        if let prefixExpr = syntax.as(PrefixOperatorExprSyntax.self),
           prefixExpr.operator.text == "-",
           let value = prefixExpr.expression.as(IntegerLiteralExprSyntax.self)?.representedLiteralValue {
            self = -value
            return
        }
        guard let value = syntax.as(IntegerLiteralExprSyntax.self)?.representedLiteralValue
        else { return nil }
        self = value
    }
}

extension Double: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle negative numbers: -10.5 is parsed as PrefixOperatorExpr("-", FloatLiteralExpr)
        if let prefixExpr = syntax.as(PrefixOperatorExprSyntax.self),
           prefixExpr.operator.text == "-" {
            if let value = prefixExpr.expression.as(FloatLiteralExprSyntax.self)?.representedLiteralValue {
                self = -value
                return
            } else if let value = prefixExpr.expression.as(IntegerLiteralExprSyntax.self)?.representedLiteralValue {
                self = -Double(value)
                return
            }
        }
        guard let value = syntax.as(FloatLiteralExprSyntax.self)?.representedLiteralValue
            ?? Int(syntax: syntax).flatMap(Double.init)
        else { return nil }
        self = value
    }
}

extension CGFloat: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle negative numbers via Double which already handles PrefixOperatorExpr
        if let value = Double(syntax: syntax) {
            self = CGFloat(value)
            return
        }
        return nil
    }
}

extension String: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let value = syntax.as(StringLiteralExprSyntax.self)?.segments.compactMap({ (segment) -> String? in
            guard case let .stringSegment(literal) = segment else { return nil }
            return literal.content.text
        }).joined()
        else { return nil }
        self = value
    }
}

extension Bool: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        switch syntax.as(BooleanLiteralExprSyntax.self)?.literal.tokenKind {
        case .keyword(.true):
            self = true
        case .keyword(.false):
            self = false
        default:
            return nil
        }
    }
}

extension Set: SyntaxConvertible where Element: SyntaxConvertible & Hashable {
    public init?(syntax: some SyntaxProtocol) {
        // Handle array syntax like [.medium, .large] or ["event1", "event2"]
        if let arrayExpr = syntax.as(ArrayExprSyntax.self) {
            var elements = Set<Element>()
            for arrayElement in arrayExpr.elements {
                if let element = Element(syntax: arrayElement.expression) {
                    elements.insert(element)
                } else {
                    return nil
                }
            }
            self = elements
            return
        }

        // Handle single element
        if let element = Element(syntax: syntax) {
            self = [element]
            return
        }

        return nil
    }
}
