import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.focusedSceneValue(_:_:)` modifier CANNOT be supported in LightpandaRenderer
/// because it requires compile-time type information that cannot be parsed at runtime.
///
/// The modifier signature is:
/// ```swift
/// func focusedSceneValue<T>(_ keyPath: WritableKeyPath<FocusedValues, T?>, _ value: T) -> some View
/// ```
///
/// This requires:
/// 1. `FocusedValueKey` protocol conformance must be defined at compile time
/// 2. `FocusedValues` must be extended with a computed property at compile time
/// 3. `WritableKeyPath<FocusedValues, Value?>` references that compile-time property
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
/// // Then use: .focusedSceneValue(\.myValue, someString)
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
/// This modifier is intentionally disabled and will throw a parse error.
///
/// Available: iOS 15.0+, macOS 12.0+, tvOS 15.0+, watchOS 8.0+, visionOS 1.0+
/// See: https://developer.apple.com/documentation/swiftui/view/focusedscenevalue(_:_:)-57boz
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
public enum FocusedSceneValueModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
extension FocusedSceneValueModifier: RuntimeViewModifier {
    public static var baseName: String { "focusedSceneValue" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The focusedSceneValue modifier requires a WritableKeyPath<FocusedValues, T?> as its first argument.
        // This key path must reference a property defined at compile time through:
        // 1. A type conforming to FocusedValueKey protocol
        // 2. An extension of FocusedValues with a computed property
        //
        // These cannot be created at runtime because:
        // - Protocol conformances must be defined at compile time
        // - Type extensions cannot be created dynamically
        // - Key paths to non-existent properties cannot be constructed
        //
        // Use the focused($binding) modifier for focus state management in LightpandaRenderer.
        throw ModifierParseError.keyPathNotSupported(
            modifier: "focusedSceneValue",
            suggestion: "Use focused($isFocused) for boolean focus state, or focused($focusedField, equals: .fieldName) for enum-style focus"
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}