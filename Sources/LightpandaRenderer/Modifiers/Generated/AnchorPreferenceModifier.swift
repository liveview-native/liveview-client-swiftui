import SwiftUI
import SwiftSyntax

/// AnchorPreferenceModifier - NOT IMPLEMENTED
///
/// This modifier cannot be implemented in the LightpandaRenderer runtime template system because:
///
/// 1. **PreferenceKey protocol requirement**: SwiftUI's `anchorPreference(key:value:transform:)` requires a type
///    conforming to `PreferenceKey` with:
///    - An associated `Value` type
///    - A `defaultValue` static property
///    - A `reduce(value:nextValue:)` static method for combining values
///
/// 2. **Compile-time type definition**: The `K` generic parameter must be a concrete type known at compile time.
///    It cannot be resolved from string syntax at runtime.
///
/// 3. **Transform closure**: The `transform: (Anchor<A>) -> K.Value` closure cannot be parsed from HTML attributes.
///    Closures require Swift code, which cannot be provided through runtime string parsing.
///
/// 4. **Anchor generic type**: The `A` type parameter (representing the anchor source type like `CGRect` for `.bounds`)
///    must also be known at compile time.
///
/// **SwiftUI signature:**
/// ```swift
/// func anchorPreference<A, K>(
///     key _: K.Type = K.self,
///     value: Anchor<A>.Source,
///     transform: @escaping (Anchor<A>) -> K.Value
/// ) -> some View where K : PreferenceKey
/// ```
///
/// **How anchor preferences work in SwiftUI:**
/// - Child views capture geometry via `.anchorPreference(key:value:transform:)`
/// - The `value` parameter specifies which geometry to capture (e.g., `.bounds`, `.center`)
/// - The `transform` closure converts the `Anchor<A>` to the preference key's value type
/// - Parent views can resolve anchors to their local coordinate space via `GeometryProxy.value(for:)`
///
/// **Alternative approaches for LightpandaRenderer:**
/// - Use `onGeometryChange(for:of:action:)` modifier (iOS 16+) to observe geometry changes
/// - Use JavaScript events with `Node.callFunction` to communicate geometry data
/// - Store geometry state in JavaScript and observe via CDP bindings
///
/// **References:**
/// - https://developer.apple.com/documentation/swiftui/view/anchorpreference(key:value:transform:)
/// - https://developer.apple.com/documentation/swiftui/anchor
/// - https://developer.apple.com/documentation/swiftui/preferencekey
@MainActor
public enum AnchorPreferenceModifier<Library: ElementLibrary>: @unchecked Sendable {
    // No cases - modifier is not implemented
    case notImplemented
}

extension AnchorPreferenceModifier: RuntimeViewModifier {
    public static var baseName: String { "anchorPreference" }

    public init(syntax: FunctionCallExprSyntax) throws {
        throw ModifierParseError.noMatchingVariant(
            modifier: "AnchorPreferenceModifier",
            errors: [AnchorPreferenceModifierError.notImplemented]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This should never be called since init always throws
        _content
    }
}

private enum AnchorPreferenceModifierError: Error, LocalizedError {
    case notImplemented

    var errorDescription: String? {
        """
        anchorPreference(key:value:transform:) is not implemented. This modifier requires: \
        (1) a concrete type conforming to PreferenceKey defined at compile time, and \
        (2) a transform closure (Anchor<A>) -> K.Value. Neither can be provided through \
        HTML attributes. Consider using onGeometryChange(for:of:action:) modifier or \
        JavaScript events to communicate geometry data up the view hierarchy.
        """
    }
}