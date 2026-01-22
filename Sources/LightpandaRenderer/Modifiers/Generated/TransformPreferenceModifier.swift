import SwiftUI
import SwiftSyntax

/// TransformPreferenceModifier - NOT IMPLEMENTED
///
/// This modifier cannot be implemented in the LightpandaRenderer runtime template system because:
///
/// 1. **PreferenceKey protocol requirement**: SwiftUI's `transformPreference(_:_:)` requires a type
///    conforming to `PreferenceKey` with:
///    - An associated `Value` type
///    - A `defaultValue` static property
///    - A `reduce(value:nextValue:)` static method for combining values
///
/// 2. **Compile-time type definition**: The `K` generic parameter in `.transformPreference(K.Type, _:)`
///    must be a concrete type known at compile time. It cannot be resolved from string syntax at runtime.
///
/// 3. **Closure parameter**: The transform closure `(inout K.Value) -> Void` cannot be parsed from
///    syntax or provided through HTML attributes.
///
/// **How transformPreference works in SwiftUI:**
/// - Applies a transformation to a preference value as it propagates up the view hierarchy
/// - The closure receives the current accumulated preference value and can modify it in place
/// - Useful for transforming coordinate spaces, combining values, or filtering preference data
///
/// **SwiftUI signature:**
/// ```swift
/// func transformPreference<K>(_ key: K.Type = K.self, _ transform: @escaping (inout K.Value) -> Void) -> some View where K : PreferenceKey
/// ```
///
/// **Alternative approaches for LightpandaRenderer:**
/// - Use JavaScript events to communicate child -> parent data
/// - Use `Node.callFunction` to dispatch CustomEvents with data payloads
/// - Store shared state in JavaScript and observe via CDP bindings
///
/// **References:**
/// - https://developer.apple.com/documentation/swiftui/view/transformpreference(_:_:)
/// - https://developer.apple.com/documentation/swiftui/preferencekey
@MainActor
public enum TransformPreferenceModifier<Library: ElementLibrary>: @unchecked Sendable {
    // No cases - modifier is not implemented
    case notImplemented
}

extension TransformPreferenceModifier: RuntimeViewModifier {
    public static var baseName: String { "transformPreference" }

    public init(syntax: FunctionCallExprSyntax) throws {
        throw ModifierParseError.noMatchingVariant(
            modifier: "TransformPreferenceModifier",
            errors: [TransformPreferenceModifierError.notImplemented]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This should never be called since init always throws
        _content
    }
}

private enum TransformPreferenceModifierError: Error, LocalizedError {
    case notImplemented

    var errorDescription: String? {
        """
        transformPreference(_:_:) is not implemented. This modifier requires a concrete type \
        conforming to PreferenceKey (which must be defined at compile time with associated \
        Value type, defaultValue, and reduce function) and a transform closure. These cannot \
        be provided through HTML attributes. Consider using JavaScript events to communicate \
        data up the view hierarchy.
        """
    }
}
