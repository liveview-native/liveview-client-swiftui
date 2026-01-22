import SwiftUI
import SwiftSyntax

// MARK: - KeyframeAnimatorModifier is NOT SUPPORTED
//
// SwiftUI's keyframeAnimator modifier cannot be implemented in LightpandaRenderer because:
//
// 1. The `content` closure receives BOTH the view AND the animated value:
//    ```swift
//    .keyframeAnimator(initialValue: AnimationValues()) { content, value in
//        content
//            .scaleEffect(value.scale)  // <-- uses `value` to determine modifiers
//            .opacity(value.opacity)
//    } keyframes: { _ in
//        KeyframeTrack(\.scale) { ... }
//        KeyframeTrack(\.opacity) { ... }
//    }
//    ```
//
// 2. The animated value determines which modifiers are applied to the content.
//    This requires runtime evaluation of interpolated keyframe values, which cannot be
//    expressed in declarative markup.
//
// 3. The `keyframes` closure builds keyframe tracks using key paths, which also cannot
//    be parsed from syntax.
//
// Alternative approaches considered and rejected:
// - Using template references: Templates can't receive animated value parameters
// - Using NodeBinding: Bindings are for two-way sync, not view transformation
// - Hardcoding specific animations: Would be too limited to be useful
//
// If you need keyframe-based animations, consider using:
// - `animation(_:value:)` with attribute-driven triggers
// - CSS animations via the web layer
// - Custom SwiftUI views with internal state
// - Native SwiftUI `KeyframeAnimator` in your custom view implementations

/// Modifier for SwiftUI's keyframeAnimator.
/// This modifier is NOT supported in LightpandaRenderer because the content and keyframes
/// closures require runtime access to interpolated values that cannot be expressed in markup.
///
/// Available in iOS 17.0+, macOS 14.0+, tvOS 17.0+, watchOS 10.0+
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum KeyframeAnimatorModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension KeyframeAnimatorModifier: RuntimeViewModifier {
    public static var baseName: String { "keyframeAnimator" }

    public init(syntax: FunctionCallExprSyntax) throws {
        throw ModifierParseError.noMatchingVariant(
            modifier: "KeyframeAnimatorModifier",
            errors: [ModifierParseError.missingRequiredArgument(
                modifier: "KeyframeAnimatorModifier",
                argument: "keyframeAnimator is not supported - the content and keyframes closures require runtime access to interpolated values that cannot be expressed in declarative markup. See comments in KeyframeAnimatorModifier.swift for alternatives."
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
