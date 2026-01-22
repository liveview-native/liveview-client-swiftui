import SwiftUI
import SwiftSyntax

/// BackgroundPreferenceValueModifier - NOT IMPLEMENTED
///
/// This modifier cannot be implemented in the LightpandaRenderer runtime template system because:
///
/// 1. **PreferenceKey protocol requirement**: SwiftUI's `backgroundPreferenceValue(_:_:)` requires a type
///    conforming to `PreferenceKey` with:
///    - An associated `Value` type
///    - A `defaultValue` static property
///    - A `reduce(value:nextValue:)` static method for combining values
///
/// 2. **Compile-time type definition**: The generic parameter in `.backgroundPreferenceValue(_:_:)`
///    must be a concrete type known at compile time. It cannot be resolved from string syntax at runtime.
///
/// 3. **Protocol conformance**: PreferenceKey types must be defined in Swift code with their reduce logic,
///    which determines how values from multiple children are combined. This cannot be expressed in HTML attributes.
///
/// 4. **Closure requirement**: The second parameter is a closure `(Value) -> some View` that transforms
///    the preference value into a view. Closures cannot be parsed from syntax at runtime.
///
/// **How backgroundPreferenceValue works in SwiftUI:**
/// - Child views set preference values via `.preference(key:value:)`
/// - Values propagate up the view hierarchy
/// - `backgroundPreferenceValue(_:_:)` reads the accumulated value and produces a background view
/// - The background is placed behind the original content
///
/// **Alternative approaches for LightpandaRenderer:**
/// - Use JavaScript events to communicate child -> parent data
/// - Use `Node.callFunction` to dispatch CustomEvents with data payloads
/// - Store shared state in JavaScript and observe via CDP bindings
/// - Use `.overlay` or `.background` modifiers with static views
///
/// **References:**
/// - https://developer.apple.com/documentation/swiftui/view/backgroundpreferencevalue(_:_:)
/// - https://developer.apple.com/documentation/swiftui/preferencekey
@MainActor
public enum BackgroundPreferenceValueModifier<Library: ElementLibrary>: @unchecked Sendable {
    // No cases - modifier is not implemented
    case notImplemented
}

extension BackgroundPreferenceValueModifier: RuntimeViewModifier {
    public static var baseName: String { "backgroundPreferenceValue" }

    public init(syntax: FunctionCallExprSyntax) throws {
        throw ModifierParseError.noMatchingVariant(
            modifier: "BackgroundPreferenceValueModifier",
            errors: [BackgroundPreferenceValueModifierError.notImplemented]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This should never be called since init always throws
        _content
    }
}

private enum BackgroundPreferenceValueModifierError: Error, LocalizedError {
    case notImplemented

    var errorDescription: String? {
        """
        backgroundPreferenceValue(_:_:) is not implemented. This modifier requires a concrete type \
        conforming to PreferenceKey, which must be defined at compile time with associated \
        Value type, defaultValue, and reduce function. Additionally, the transform closure cannot be \
        provided through HTML attributes. Consider using JavaScript events to communicate data up the \
        view hierarchy, or use .background() modifier with static views.
        """
    }
}