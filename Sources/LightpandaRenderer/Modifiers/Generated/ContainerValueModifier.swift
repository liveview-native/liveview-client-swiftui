import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.containerValue(_:_:)` modifier sets a container value using a
/// `WritableKeyPath<ContainerValues, V>` as its first argument.
///
/// The modifier signature is:
/// ```swift
/// func containerValue<V>(_ keyPath: WritableKeyPath<ContainerValues, V>, _ value: V) -> some View
/// ```
///
/// Container values are user-defined properties on `ContainerValues` using the `@Entry` macro:
/// ```swift
/// extension ContainerValues {
///     @Entry var isFeatured = false
/// }
/// ```
///
/// This cannot be supported at runtime because:
/// 1. Container value properties are defined by users via `@Entry` macro
/// 2. The keypath type `WritableKeyPath<ContainerValues, V>` requires compile-time knowledge
///    of the specific property being accessed
/// 3. There are no built-in container values that could be pre-defined
///
/// Container values are designed for custom container views that iterate over subviews
/// and need to pass metadata. In LightpandaRenderer, consider using:
/// - Element attributes to store metadata on nodes
/// - The environment modifier for built-in environment values
/// - Custom element types with specific properties
///
/// This modifier is intentionally disabled and will throw a parse error.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public enum ContainerValueModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension ContainerValueModifier: RuntimeViewModifier {
    public static var baseName: String { "containerValue" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The containerValue modifier requires a WritableKeyPath<ContainerValues, V> as its first argument.
        // Container values are user-defined properties created via the @Entry macro on ContainerValues.
        // Because these properties are defined by users at compile time, we cannot know which
        // keypaths exist or their associated value types at runtime.
        //
        // For example, a user might define:
        //   extension ContainerValues {
        //       @Entry var myCustomValue = ""
        //   }
        //
        // And use it as: .containerValue(\.myCustomValue, "hello")
        //
        // We cannot parse this keypath from syntax because:
        // 1. The property name "myCustomValue" requires compile-time knowledge of the extension
        // 2. The value type V is inferred from the property definition
        // 3. WritableKeyPath cannot be dynamically constructed from a string
        throw ModifierParseError.noMatchingVariant(
            modifier: "ContainerValueModifier",
            errors: [ModifierParseError.keyPathNotSupported(
                modifier: "containerValue",
                suggestion: "Container values are user-defined via the @Entry macro on ContainerValues. Use element attributes to store metadata on nodes instead."
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
