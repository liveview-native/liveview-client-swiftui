import SwiftUI
import Foundation

/// A macro that can decode a type from a JSON representation of an AST node.
///
/// - Parameter identifier The name of the node, matched from the first element in a node tuple.
@attached(
    extension,
    conformances: Swift.Decodable,
    names: named(init(from:)), named(Resolvable)
)
public macro ASTDecodable(
    _ identifier: StaticString,
    options: ASTDecodableOptions...
) = #externalMacro(module: "LiveViewNativeStylesheetMacros", type: "ASTDecodable")

public enum ASTDecodableOptions {
    case none
}

public enum ASTDecodableError: Error {
    case _tooManyArguments
    
    public static var tooManyArguments: Self {
        return ._tooManyArguments
    }
}

public struct MultipleFailures: Error {
    let errors: [any Error]
    let annotations: Annotations?
    
    public init(_ errors: [any Error], annotations: Annotations? = nil) {
        self.errors = errors
        self.annotations = annotations
    }
}
