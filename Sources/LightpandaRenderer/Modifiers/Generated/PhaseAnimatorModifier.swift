import SwiftUI
import SwiftSyntax

// MARK: - PhaseAnimatorModifier is NOT SUPPORTED
//
// SwiftUI's phaseAnimator modifier cannot be implemented in LightpandaRenderer because:
//
// 1. The `content` closure receives BOTH the view AND the current phase value:
//    ```swift
//    .phaseAnimator([false, true]) { content, phase in
//        content
//            .opacity(phase ? 1.0 : 0.5)  // <-- uses `phase` value
//            .scaleEffect(phase ? 1.0 : 0.8)
//    }
//    ```
//
// 2. The phase value determines which modifiers are applied to the content.
//    This requires runtime evaluation of the phase value, which cannot be
//    expressed in declarative markup.
//
// 3. The phases can be any Equatable type, not just Bool.
//
// Alternative approaches considered and rejected:
// - Using template references: Templates can't receive phase parameters
// - Using NodeBinding: Bindings are for two-way sync, not view transformation
// - Hardcoding Bool phases: Would still require content closure to use the value
//
// If you need animated state transitions, consider using:
// - `animation(_:value:)` with attribute-driven triggers
// - CSS animations via the web layer
// - Custom SwiftUI views with internal state

// Placeholder to prevent build errors - this modifier is intentionally not parseable
/*
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum PhaseAnimatorModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension PhaseAnimatorModifier: RuntimeViewModifier {
    public static var baseName: String { "phaseAnimator" }

    public init(syntax: FunctionCallExprSyntax) throws {
        throw ModifierParseError.noMatchingVariant(
            modifier: "PhaseAnimatorModifier",
            errors: [ModifierParseError.missingRequiredArgument(
                modifier: "PhaseAnimatorModifier",
                argument: "phaseAnimator is not supported - see comments in PhaseAnimatorModifier.swift"
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        _content
    }
}
*/
