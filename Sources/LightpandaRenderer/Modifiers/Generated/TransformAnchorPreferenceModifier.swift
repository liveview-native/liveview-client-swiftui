import SwiftUI
import SwiftSyntax

/// TransformAnchorPreferenceModifier - NOT IMPLEMENTED
///
/// This modifier cannot be implemented in the LightpandaRenderer runtime template system because:
///
/// 1. **PreferenceKey protocol requirement**: SwiftUI's `transformAnchorPreference(key:value:transform:)`
///    requires a type conforming to `PreferenceKey` with:
///    - An associated `Value` type
///    - A `defaultValue` static property
///    - A `reduce(value:nextValue:)` static method for combining values
///
/// 2. **Compile-time type definition**: The `K` generic parameter in
///    `.transformAnchorPreference(key: K.Type, value: Anchor<A>.Source, transform: (inout K.Value, Anchor<A>) -> Void)`
///    must be a concrete type known at compile time. It cannot be resolved from string syntax at runtime.
///
/// 3. **Closure requirement**: The `transform` parameter is a closure that receives an inout reference
///    to the preference value and an Anchor. Closures cannot be instantiated from syntax strings.
///
/// 4. **Protocol conformance**: PreferenceKey types must be defined in Swift code with their reduce logic,
///    which determines how values from multiple children are combined. This cannot be expressed in HTML attributes.
///
/// **How transformAnchorPreference works in SwiftUI:**
/// - Similar to `anchorPreference`, but transforms an existing preference value
/// - The transform closure receives the current value (inout) and the anchor
/// - Used to accumulate geometry information from multiple views
/// - Values propagate up the view hierarchy
///
/// **Alternative approaches for LightpandaRenderer:**
/// - Use JavaScript events to communicate child to parent geometry data
/// - Use `Node.callFunction` to dispatch CustomEvents with coordinate payloads
/// - Use `onGeometryChange(for:of:action:)` modifier for geometry updates (iOS 16+)
/// - Store shared state in JavaScript and observe via CDP bindings
///
/// **References:**
/// - https://developer.apple.com/documentation/swiftui/view/transformanchorpreference(key:value:transform:)
/// - https://developer.apple.com/documentation/swiftui/preferencekey
@MainActor
public enum TransformAnchorPreferenceModifier<Library: ElementLibrary>: @unchecked Sendable {
    // No cases - modifier is not implemented
    case notImplemented
}

extension TransformAnchorPreferenceModifier: RuntimeViewModifier {
    public static var baseName: String { "transformAnchorPreference" }

    public init(syntax: FunctionCallExprSyntax) throws {
        throw ModifierParseError.noMatchingVariant(
            modifier: "TransformAnchorPreferenceModifier",
            errors: [TransformAnchorPreferenceModifierError.notImplemented]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This should never be called since init always throws
        _content
    }
}

private enum TransformAnchorPreferenceModifierError: Error, LocalizedError {
    case notImplemented

    var errorDescription: String? {
        """
        transformAnchorPreference(key:value:transform:) is not implemented. This modifier requires a concrete type \
        conforming to PreferenceKey, which must be defined at compile time with associated \
        Value type, defaultValue, and reduce function. Additionally, the transform parameter \
        is a closure that cannot be parsed from syntax strings. These cannot be provided through \
        HTML attributes. Consider using onGeometryChange(for:of:action:) or JavaScript events \
        to communicate geometry data up the view hierarchy.
        """
    }
}