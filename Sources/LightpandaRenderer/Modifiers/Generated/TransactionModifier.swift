import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.transaction(_:)` modifier takes a closure that mutates
/// an `inout Transaction`, allowing modification of animation properties.
/// Since closures cannot be parsed from syntax at runtime, this modifier
/// CANNOT be supported.
///
/// All variants of the transaction modifier require a closure:
/// - `transaction(_:)` - Closure `(inout Transaction) -> Void`
/// - `transaction(value:_:)` - Closure `(inout Transaction) -> Void` (iOS 17+)
/// - `transaction(_:body:)` - Closure `(inout Transaction) -> Void`
///
/// For controlling animations, use the `.animation(_:)` or `.animation(_:value:)`
/// modifiers instead, which can specify animations declaratively without closures.
///
/// This modifier is intentionally disabled and will throw a parse error.
public enum TransactionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

extension TransactionModifier: RuntimeViewModifier {
    public static var baseName: String { "transaction" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The transaction modifier requires a closure that takes (inout Transaction)
        // and mutates it to control animation behavior. This cannot be parsed from
        // syntax at runtime.
        //
        // Closures are required because the modifier's purpose is to mutate the
        // Transaction's properties (like animation, disablesAnimations, etc.)
        // which requires imperative code execution.
        throw ModifierParseError.noMatchingVariant(
            modifier: "TransactionModifier",
            errors: [ModifierParseError.closureNotSupported(
                modifier: "transaction",
                suggestion: "Use .animation(_:) or .animation(_:value:) modifiers instead to control animations declaratively"
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}