import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.transformEnvironment(_:transform:)` modifier takes a
/// WritableKeyPath and a closure that mutates the environment value in-place.
/// Since closures cannot be parsed from syntax at runtime, this modifier
/// CANNOT be fully supported.
///
/// The modifier signature is:
/// ```swift
/// func transformEnvironment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, transform: @escaping (inout V) -> Void) -> some View
/// ```
///
/// This requires:
/// 1. A WritableKeyPath to an environment value
/// 2. A closure that mutates the value via an inout parameter
///
/// The closure cannot be parsed from syntax strings at runtime because it needs
/// to execute arbitrary Swift code with access to the current value.
///
/// For setting environment values, use the `environment(_:_:)` modifier instead:
/// - `.environment(\.colorScheme, .dark)`
/// - `.environment(\.layoutDirection, .rightToLeft)`
/// - `.environment(\.isEnabled, false)`
///
/// This modifier is intentionally disabled and will throw a parse error.
public enum TransformEnvironmentModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

extension TransformEnvironmentModifier: RuntimeViewModifier {
    public static var baseName: String { "transformEnvironment" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The transformEnvironment modifier requires a closure that takes an inout parameter
        // and mutates the environment value. This cannot be parsed from syntax at runtime.
        //
        // Unlike the simpler `environment(_:_:)` modifier which sets a fixed value,
        // transformEnvironment is designed to modify an existing value based on arbitrary logic.
        // Without closure support, this modifier cannot provide its intended functionality.
        //
        // Use the environment(_:_:) modifier to set specific environment values instead.
        throw ModifierParseError.noMatchingVariant(
            modifier: "TransformEnvironmentModifier",
            errors: [ModifierParseError.closureNotSupported(
                modifier: "transformEnvironment",
                suggestion: "Use environment(_:_:) to set environment values directly. For example: .environment(\\.colorScheme, .dark)"
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}