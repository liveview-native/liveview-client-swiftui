import SwiftUI
import SwiftSyntax

/// OverlayPreferenceValueModifier - NOT IMPLEMENTED
///
/// This modifier cannot be implemented in the LightpandaRenderer runtime template system because:
///
/// 1. **PreferenceKey protocol requirement**: SwiftUI's `overlayPreferenceValue(_:_:)` requires a type
///    conforming to `PreferenceKey` with:
///    - An associated `Value` type
///    - A `defaultValue` static property
///    - A `reduce(value:nextValue:)` static method for combining values
///
/// 2. **Compile-time type definition**: The `Key` generic parameter in `.overlayPreferenceValue(Key.Type, ...)`
///    must be a concrete type known at compile time. It cannot be resolved from string syntax at runtime.
///
/// 3. **Closure requirement**: The transform closure `(Key.Value) -> some View` cannot be expressed
///    in HTML attributes since it requires dynamic code execution.
///
/// **How overlayPreferenceValue works in SwiftUI:**
/// - Reads a preference value that was set by child views via `.preference(key:value:)`
/// - Uses that value to produce an overlay view that is applied on top of the content
/// - The overlay is re-rendered whenever the preference value changes
///
/// **SwiftUI signatures:**
/// ```swift
/// func overlayPreferenceValue<K>(_ key: K.Type, @ViewBuilder _ transform: @escaping (K.Value) -> some View) -> some View where K : PreferenceKey
/// func overlayPreferenceValue<K>(_ key: K.Type, alignment: Alignment, @ViewBuilder _ transform: @escaping (K.Value) -> some View) -> some View where K : PreferenceKey
/// ```
///
/// **Alternative approaches for LightpandaRenderer:**
/// - Use JavaScript to compute overlay positioning based on child element measurements
/// - Use absolute positioning with JavaScript-calculated coordinates
/// - Use `Node.callFunction` to dispatch CustomEvents with geometric data payloads
///
/// **References:**
/// - https://developer.apple.com/documentation/swiftui/view/overlaypreferencevalue(_:_:)
/// - https://developer.apple.com/documentation/swiftui/view/overlaypreferencevalue(_:alignment:_:)
/// - https://developer.apple.com/documentation/swiftui/preferencekey
@MainActor
public enum OverlayPreferenceValueModifier<Library: ElementLibrary>: @unchecked Sendable {
    // No cases - modifier is not implemented
    case notImplemented
}

extension OverlayPreferenceValueModifier: RuntimeViewModifier {
    public static var baseName: String { "overlayPreferenceValue" }

    public init(syntax: FunctionCallExprSyntax) throws {
        throw ModifierParseError.noMatchingVariant(
            modifier: "OverlayPreferenceValueModifier",
            errors: [OverlayPreferenceValueModifierError.notImplemented]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This should never be called since init always throws
        _content
    }
}

private enum OverlayPreferenceValueModifierError: Error, LocalizedError {
    case notImplemented

    var errorDescription: String? {
        """
        overlayPreferenceValue(_:_:) is not implemented. This modifier requires a concrete type \
        conforming to PreferenceKey, which must be defined at compile time with associated \
        Value type, defaultValue, and reduce function. Additionally, it requires a transform closure \
        that produces a View based on the preference value. These cannot be provided through \
        HTML attributes. Consider using JavaScript to compute overlay positioning based on \
        child element measurements.
        """
    }
}
