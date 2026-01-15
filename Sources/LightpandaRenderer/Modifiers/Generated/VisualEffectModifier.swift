import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.visualEffect(_:)` modifier takes a closure that receives
/// an EmptyVisualEffect and GeometryProxy, and returns a VisualEffect.
/// Since closures cannot be parsed from syntax at runtime, this modifier
/// CANNOT be fully supported.
///
/// The power of visualEffect is applying transformations based on geometry
/// (e.g., scrolling position), which requires runtime closure evaluation.
///
/// For static visual effects, use the individual modifiers instead:
/// - scaleEffect(_:anchor:)
/// - rotationEffect(_:anchor:)
/// - offset(x:y:)
/// - blur(radius:opaque:)
/// - opacity(_:)
///
/// This modifier is intentionally disabled and will throw a parse error.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum VisualEffectModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension VisualEffectModifier: RuntimeViewModifier {
    public static var baseName: String { "visualEffect" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The visualEffect modifier requires a closure that takes (EmptyVisualEffect, GeometryProxy)
        // and returns some VisualEffect. This cannot be parsed from syntax at runtime.
        //
        // The closure provides access to geometry information that allows creating dynamic
        // effects based on scroll position, view size, etc. Without closure support,
        // this modifier provides no value over individual effect modifiers.
        throw ModifierParseError.noMatchingVariant(
            modifier: "VisualEffectModifier",
            errors: [ModifierParseError.closureNotSupported(
                modifier: "visualEffect",
                suggestion: "Use individual effect modifiers like scaleEffect(), rotationEffect(), offset(), blur(), or opacity() instead"
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
