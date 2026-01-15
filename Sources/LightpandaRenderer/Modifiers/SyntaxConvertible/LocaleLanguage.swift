import Foundation
import SwiftSyntax

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Locale.Language: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Parse string literals like "en", "ja", "ar", etc.
        if let stringLiteral = syntax.as(StringLiteralExprSyntax.self),
           let identifier = stringLiteral.segments.compactMap({ segment -> String? in
               guard case let .stringSegment(literal) = segment else { return nil }
               return literal.content.text
           }).joined() as String? {
            self.init(identifier: identifier)
            return
        }

        // Parse function calls like Locale.Language("en") or Language("en")
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let firstArg = functionCall.arguments.first,
           let identifier = String(syntax: firstArg.expression) {
            self.init(identifier: identifier)
            return
        }

        return nil
    }
}
