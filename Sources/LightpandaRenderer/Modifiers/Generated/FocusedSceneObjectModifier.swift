import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.focusedSceneObject(_:)` modifier requires an ObservableObject
/// instance as its argument. ObservableObject instances are runtime objects that
/// maintain state and publish changes, and cannot be instantiated from syntax at parse time.
///
/// The modifier signature is:
/// ```swift
/// func focusedSceneObject<T>(_ object: T) -> some View where T: ObservableObject
/// func focusedSceneObject<T>(_ object: T?) -> some View where T: ObservableObject
/// ```
///
/// This requires:
/// 1. An instance of a class conforming to ObservableObject
/// 2. The type `T` to be known at compile time
///
/// Neither of these can be parsed from syntax strings at runtime because:
/// - ObservableObject instances must be created programmatically with proper initialization
/// - The generic type parameter `T` must be a concrete type known at compile time
/// - The object instance needs to have a lifecycle managed by SwiftUI
///
/// For focus-related functionality in LightpandaRenderer, use:
/// - `FocusedModifier` with `focused($isFocused)` for boolean focus state
/// - `focused($focusedField, equals: .fieldName)` for enum-style focus
/// - JavaScript event listeners for focus change notifications
///
/// This modifier is intentionally disabled and will throw a parse error.
///
/// Platform availability: iOS 15.0+, macOS 12.0+, tvOS 15.0+, watchOS 8.0+, visionOS 1.0+
///
/// See: https://developer.apple.com/documentation/swiftui/view/focusedsceneobject(_:)
public enum FocusedSceneObjectModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

extension FocusedSceneObjectModifier: RuntimeViewModifier {
    public static var baseName: String { "focusedSceneObject" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The focusedSceneObject modifier requires an ObservableObject instance as its argument.
        // ObservableObject instances are runtime objects (classes with @Published properties)
        // that maintain state and publish changes. They cannot be instantiated from
        // a syntax string because:
        //
        // 1. ObservableObject requires a class instance with proper initialization
        // 2. The generic type T must conform to ObservableObject, which is a protocol
        // 3. The object's lifecycle must be managed by SwiftUI
        //
        // Use alternative patterns like the focused() modifier with NodeBinding,
        // JavaScript events, or CDP bindings for focus-related state management.
        throw ModifierParseError.protocolTypeNotSupported(
            modifier: "focusedSceneObject",
            protocolName: "ObservableObject",
            suggestion: "Use focused($attribute) for focus state binding, or JavaScript event listeners for focus change notifications"
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}