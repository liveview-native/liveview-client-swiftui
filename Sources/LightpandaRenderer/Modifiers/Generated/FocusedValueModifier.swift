import SwiftUI
import SwiftSyntax
import LightpandaClient

/// NOTE: The SwiftUI `.focusedValue(_:_:)` modifier CANNOT be supported in LightpandaRenderer
/// because it requires compile-time type information that cannot be parsed at runtime.
///
/// The modifier signature is:
/// ```swift
/// func focusedValue<Value>(_ keyPath: WritableKeyPath<FocusedValues, Value?>, _ value: Value) -> some View
/// ```
///
/// This requires:
/// 1. `FocusedValueKey` protocol conformance defined at compile time
/// 2. `FocusedValues` extended with a computed property at compile time
/// 3. `WritableKeyPath<FocusedValues, Value?>` referencing that compile-time property
///
/// Example of what would be needed (compile-time only):
/// ```swift
/// struct MyFocusedKey: FocusedValueKey {
///     typealias Value = String
/// }
/// extension FocusedValues {
///     var myValue: String? {
///         get { self[MyFocusedKey.self] }
///         set { self[MyFocusedKey.self] = newValue }
///     }
/// }
/// // Then use: .focusedValue(\.myValue, someString)
/// ```
///
/// Since we cannot:
/// - Define new FocusedValueKey conformances at runtime
/// - Extend FocusedValues at runtime
/// - Create key paths to non-existent properties
///
/// This modifier is fundamentally incompatible with runtime parsing.
///
/// For focus-related functionality in LightpandaRenderer, use the `FocusedModifier` instead:
/// - `focused($isFocused)` for boolean focus state
/// - `focused($focusedField, equals: .fieldName)` for enum-style focus
///
/// See: https://developer.apple.com/documentation/swiftui/focusedvaluekey
public enum FocusedValueModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

extension FocusedValueModifier: RuntimeViewModifier {
    public static var baseName: String { "focusedValue" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The focusedValue modifier requires a WritableKeyPath<FocusedValues, Value?> as its first argument.
        // KeyPaths to FocusedValues properties require:
        //
        // 1. A FocusedValueKey conformance defined at compile time
        // 2. An extension of FocusedValues with a computed property at compile time
        // 3. The key path itself (e.g., \.myValue) references that compile-time property
        //
        // None of these can be created at runtime from a syntax string.
        //
        // For focus-related functionality, use the FocusedModifier instead:
        // - focused($isFocused) for boolean focus state
        // - focused($focusedField, equals: .fieldName) for enum-style focus
        throw ModifierParseError.noMatchingVariant(
            modifier: "FocusedValueModifier",
            errors: [ModifierParseError.protocolTypeNotSupported(
                modifier: "focusedValue",
                protocolName: "FocusedValueKey",
                suggestion: "Use focused($isFocused) for boolean focus state, or focused($focusedField, equals: .fieldName) for enum-style focus"
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
