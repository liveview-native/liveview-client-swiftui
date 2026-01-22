import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.layoutValue(key:value:)` modifier requires a type conforming to
/// `LayoutValueKey` protocol as its first argument. This protocol has an associated type
/// (`Value`) that determines the type of the value parameter.
///
/// The modifier signature is:
/// ```swift
/// func layoutValue<K>(key: K.Type, value: K.Value) -> some View where K: LayoutValueKey
/// ```
///
/// This requires:
/// 1. A type `K` that conforms to `LayoutValueKey`
/// 2. A value of type `K.Value` (the associated type)
///
/// Neither of these can be parsed from syntax strings at runtime because:
/// - `LayoutValueKey` types are custom types defined by the user
/// - We cannot verify protocol conformance from a type name string
/// - The associated `Value` type is determined by the key type at compile time
///
/// For custom layout communication in LightpandaRenderer, use:
/// - DOM attributes on elements that your custom Layout can read
/// - The `layoutPriority(_:)` modifier for simple priority ordering
/// - Custom JavaScript-based communication patterns
///
/// This modifier is intentionally disabled and will throw a parse error.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public enum LayoutValueModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension LayoutValueModifier: RuntimeViewModifier {
    public static var baseName: String { "layoutValue" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The layoutValue modifier requires a LayoutValueKey type as its first argument.
        // LayoutValueKey is a protocol with an associated type (Value) that determines
        // the type of the second argument. These types cannot be instantiated from
        // a syntax string because:
        //
        // 1. LayoutValueKey types are custom user-defined types
        // 2. Protocol conformance cannot be verified from a string type name
        // 3. The associated Value type is determined at compile time by the key type
        //
        // Use alternative patterns like DOM attributes, layoutPriority(), or custom
        // JavaScript-based communication for layout-related data passing.
        throw ModifierParseError.noMatchingVariant(
            modifier: "LayoutValueModifier",
            errors: [ModifierParseError.protocolTypeNotSupported(
                modifier: "layoutValue",
                protocolName: "LayoutValueKey",
                suggestion: "Use DOM attributes on elements, layoutPriority(_:) for simple ordering, or JavaScript-based communication patterns"
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}