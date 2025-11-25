import SwiftSyntax
import SwiftUI

public protocol SyntaxConvertible {
    init?(syntax: some SyntaxProtocol)
}

extension FunctionCallExprSyntax {
    func argument(named name: String) -> LabeledExprSyntax? {
        return arguments.first(where: { $0.label?.text == name })
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
        guard let value = syntax.as(IntegerLiteralExprSyntax.self)?.representedLiteralValue
        else { return nil }
        self = value
    }
}

extension Double: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let value = syntax.as(FloatLiteralExprSyntax.self)?.representedLiteralValue
            ?? Int(syntax: syntax).flatMap(Double.init)
        else { return nil }
        self = value
    }
}

extension CGFloat: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let value = Double(syntax: syntax).flatMap(CGFloat.init)
                ?? Int(syntax: syntax).flatMap(CGFloat.init)
        else { return nil }
        self = value
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
