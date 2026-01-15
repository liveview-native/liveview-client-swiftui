import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.onReceive(_:perform:)` modifier takes a Combine Publisher
/// as its first argument. Publishers are runtime objects that emit values over time
/// and cannot be instantiated from syntax at parse time.
///
/// The modifier signature is:
/// ```swift
/// func onReceive<P>(_ publisher: P, perform action: @escaping (P.Output) -> Void) -> some View
///     where P: Publisher, P.Failure == Never
/// ```
///
/// This requires:
/// 1. A Publisher instance (e.g., Timer.publish(), NotificationCenter.Publisher, custom publishers)
/// 2. A closure to handle emitted values
///
/// Neither of these can be parsed from syntax strings at runtime because:
/// - Publishers are stateful objects that must be created programmatically
/// - The closure needs to execute arbitrary Swift code
///
/// For reactive updates in LightpandaRenderer, use:
/// - JavaScript event listeners for user interactions
/// - The CDP binding pattern for bidirectional state sync
/// - `onChange(of:)` modifier for observing Node attribute changes
/// - `task {}` modifier for async operations
///
/// This modifier is intentionally disabled and will throw a parse error.
public enum OnReceiveModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

extension OnReceiveModifier: RuntimeViewModifier {
    public static var baseName: String { "onReceive" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The onReceive modifier requires a Combine Publisher instance as its first argument.
        // Publishers are runtime objects (like Timer.publish(), NotificationCenter.default.publisher(),
        // or custom publishers) that emit values over time. They cannot be instantiated from
        // a syntax string because:
        //
        // 1. Publishers require runtime state and configuration
        // 2. The associated closure cannot be parsed from syntax
        // 3. Publisher types are generic and their Output type must be known at compile time
        //
        // Use alternative patterns like CDP bindings, JavaScript events, or the onChange modifier.
        throw ModifierParseError.noMatchingVariant(
            modifier: "OnReceiveModifier",
            errors: [ModifierParseError.publisherNotSupported(
                modifier: "onReceive",
                suggestion: "Use onChange(of:) for observing attribute changes, task {} for async operations, or JavaScript event listeners for reactive updates"
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
