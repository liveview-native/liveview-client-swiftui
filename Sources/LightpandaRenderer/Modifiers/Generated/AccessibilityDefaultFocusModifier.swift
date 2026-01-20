import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.accessibilityDefaultFocus(_:_:)` modifier takes an
/// `AccessibilityFocusState.Binding` as its first argument. This is a property wrapper
/// binding type that cannot be instantiated from syntax at parse time.
///
/// The modifier signature is:
/// ```swift
/// func accessibilityDefaultFocus<H>(_ binding: AccessibilityFocusState<H>.Binding, _ value: H) -> some View
///     where H: Hashable
/// ```
///
/// This requires:
/// 1. An `@AccessibilityFocusState` property wrapper declared in the view
/// 2. A hashable value to match against the focus state
///
/// The `AccessibilityFocusState.Binding` cannot be parsed from syntax strings at runtime because:
/// - It requires a declared property wrapper in the parent view
/// - The binding's storage is managed by SwiftUI's state system
/// - The generic type `H` must be known at compile time
///
/// For accessibility focus management in LightpandaRenderer, consider:
/// - Using `accessibilityFocused(_:)` if it becomes supported
/// - Managing focus through JavaScript accessibility APIs
/// - Using the CDP binding pattern for accessibility state sync
///
/// This modifier is intentionally disabled and will throw a parse error.
///
/// Available on: iOS 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+, visionOS 26.0+
public enum AccessibilityDefaultFocusModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

extension AccessibilityDefaultFocusModifier: RuntimeViewModifier {
    public static var baseName: String { "accessibilityDefaultFocus" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The accessibilityDefaultFocus modifier requires an AccessibilityFocusState.Binding
        // as its first argument. This is a property wrapper binding type that:
        //
        // 1. Must be declared as @AccessibilityFocusState in the parent view
        // 2. Has storage managed by SwiftUI's state system
        // 3. Cannot be created from a syntax string
        //
        // Use alternative patterns like JavaScript accessibility APIs or CDP bindings.
        throw ModifierParseError.protocolTypeNotSupported(
            modifier: "accessibilityDefaultFocus",
            protocolName: "AccessibilityFocusState.Binding",
            suggestion: "AccessibilityFocusState.Binding requires a declared @AccessibilityFocusState property wrapper, which cannot be created from syntax. Use JavaScript accessibility APIs for focus management."
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
