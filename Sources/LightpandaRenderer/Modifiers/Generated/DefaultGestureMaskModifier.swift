import SwiftUI
import SwiftSyntax

// MARK: - DefaultGestureMaskModifier is NOT SUPPORTED
//
// SwiftUI's defaultGestureMask modifier cannot be implemented in LightpandaRenderer because:
//
// 1. The modifier requires `SwiftUI._ScrollViewProxy` which is a private/internal SwiftUI type:
//    ```swift
//    func defaultGestureMask(proxy: _ScrollViewProxy) -> some View
//    ```
//
// 2. The underscore prefix (`_ScrollViewProxy`) indicates this is an internal implementation detail
//    of SwiftUI, not part of the public API. It cannot be instantiated or referenced in user code.
//
// 3. This modifier appears to be used internally by SwiftUI for gesture handling within scroll views,
//    but is not exposed as a public API for developers to use.
//
// NOTE: This is different from the public `ScrollViewProxy` type used with `ScrollViewReader`.
// The private `_ScrollViewProxy` type has no documented public initializers or properties.
//
// If you need gesture handling in scroll views, consider using:
// - `gesture(_:including:)` with `GestureMask` options (.gesture, .subviews, .all, .none)
// - `simultaneousGesture(_:including:)` for non-blocking gestures
// - `highPriorityGesture(_:including:)` for priority gesture handling
// - Custom gesture recognizers in UIKit/AppKit bridging

/// Modifier for SwiftUI's defaultGestureMask.
/// This modifier is NOT supported in LightpandaRenderer because it requires `SwiftUI._ScrollViewProxy`,
/// a private/internal SwiftUI type that cannot be instantiated from user code.
public enum DefaultGestureMaskModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

extension DefaultGestureMaskModifier: RuntimeViewModifier {
    public static var baseName: String { "defaultGestureMask" }

    public init(syntax: FunctionCallExprSyntax) throws {
        throw ModifierParseError.noMatchingVariant(
            modifier: "DefaultGestureMaskModifier",
            errors: [ModifierParseError.missingRequiredArgument(
                modifier: "DefaultGestureMaskModifier",
                argument: "defaultGestureMask is not supported - it requires SwiftUI._ScrollViewProxy which is a private/internal SwiftUI type. Consider using gesture(_:including:) with GestureMask options instead."
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
