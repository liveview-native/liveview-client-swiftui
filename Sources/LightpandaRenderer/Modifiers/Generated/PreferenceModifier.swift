import SwiftUI
import SwiftSyntax

/// PreferenceModifier - NOT IMPLEMENTED
///
/// This modifier cannot be implemented in the LightpandaRenderer runtime template system because:
///
/// 1. **PreferenceKey protocol requirement**: SwiftUI's `preference(key:value:)` requires a type
///    conforming to `PreferenceKey` with:
///    - An associated `Value` type
///    - A `defaultValue` static property
///    - A `reduce(value:nextValue:)` static method for combining values
///
/// 2. **Compile-time type definition**: The `K` generic parameter in `.preference(key: K.Type, value: K.Value)`
///    must be a concrete type known at compile time. It cannot be resolved from string syntax at runtime.
///
/// 3. **Protocol conformance**: PreferenceKey types must be defined in Swift code with their reduce logic,
///    which determines how values from multiple children are combined. This cannot be expressed in HTML attributes.
///
/// **How preferences work in SwiftUI:**
/// - Child views set preference values via `.preference(key:value:)`
/// - Values propagate up the view hierarchy
/// - Parent views observe changes via `.onPreferenceChange(_:perform:)`
/// - Multiple values at the same level are combined using `reduce(value:nextValue:)`
///
/// **Alternative approaches for LightpandaRenderer:**
/// - Use JavaScript events to communicate child → parent data
/// - Use `Node.callFunction` to dispatch CustomEvents with data payloads
/// - Store shared state in JavaScript and observe via CDP bindings
///
/// **References:**
/// - https://developer.apple.com/documentation/swiftui/preferencekey
/// - https://developer.apple.com/documentation/swiftui/view/preference(key:value:)
@MainActor
public enum PreferenceModifier<Library: ElementLibrary>: @unchecked Sendable {
    // No cases - modifier is not implemented
    case notImplemented
}

extension PreferenceModifier: RuntimeViewModifier {
    public static var baseName: String { "preference" }

    public init(syntax: FunctionCallExprSyntax) throws {
        throw ModifierParseError.noMatchingVariant(
            modifier: "PreferenceModifier",
            errors: [PreferenceModifierError.notImplemented]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This should never be called since init always throws
        _content
    }
}

private enum PreferenceModifierError: Error, LocalizedError {
    case notImplemented

    var errorDescription: String? {
        """
        preference(key:value:) is not implemented. This modifier requires a concrete type \
        conforming to PreferenceKey, which must be defined at compile time with associated \
        Value type, defaultValue, and reduce function. These cannot be provided through \
        HTML attributes. Consider using JavaScript events to communicate data up the view hierarchy.
        """
    }
}
