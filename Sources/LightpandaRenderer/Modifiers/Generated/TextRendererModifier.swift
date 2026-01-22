import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.textRenderer(_:)` modifier takes a TextRenderer protocol type.
/// TextRenderer requires implementing the `draw(layout:in:)` method with custom drawing
/// logic, which cannot be instantiated from syntax at runtime.
///
/// The modifier signature is:
/// ```swift
/// func textRenderer<T>(_ renderer: T) -> some View where T : TextRenderer
/// ```
///
/// This requires a TextRenderer conforming type with custom drawing implementation.
/// Such types cannot be parsed from syntax strings because they involve:
/// - Custom drawing logic in the `draw(layout:in:)` method
/// - Access to Text.Layout and GraphicsContext
/// - Optional TextAttribute implementations
///
/// TextRenderer is available on iOS 18.0+, macOS 15.0+, tvOS 18.0+, watchOS 11.0+, visionOS 2.0+.
///
/// This modifier is intentionally disabled and will throw a parse error.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public enum TextRendererModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension TextRendererModifier: RuntimeViewModifier {
    public static var baseName: String { "textRenderer" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The textRenderer modifier requires a TextRenderer protocol conforming type.
        // TextRenderer is a protocol that requires implementing:
        //   func draw(layout: Text.Layout, in context: inout GraphicsContext)
        //
        // This involves custom drawing code that cannot be parsed from syntax at runtime.
        // TextRenderer is used to create custom text rendering effects like animations,
        // glow effects, and other visual transformations.
        throw ModifierParseError.protocolTypeNotSupported(
            modifier: "textRenderer",
            protocolName: "TextRenderer",
            suggestion: "TextRenderer requires custom drawing logic that cannot be parsed from syntax. Use individual text modifiers like font(), bold(), or foregroundStyle() for static styling, or implement text rendering customization in native Swift code"
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
