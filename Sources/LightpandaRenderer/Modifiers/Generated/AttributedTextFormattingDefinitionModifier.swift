import SwiftUI
import SwiftSyntax

/// NOTE: The SwiftUI `.attributedTextFormattingDefinition(_:)` modifier takes a value
/// conforming to `AttributedTextFormattingDefinition`, which defines how text can be
/// styled in views like TextEditor.
///
/// Since `AttributedTextFormattingDefinition` is a protocol that requires a concrete
/// implementation defining attribute scopes and constraints at compile time, this
/// modifier cannot be parsed from syntax at runtime.
///
/// The modifier has three overloads:
/// - `attributedTextFormattingDefinition(_ definition: D)` where D conforms to `AttributedTextFormattingDefinition`
/// - `attributedTextFormattingDefinition(_ scope: S.Type)` where S conforms to `AttributeScope`
/// - `attributedTextFormattingDefinition(_ path: KeyPath<AttributeScopes, S.Type>)`
///
/// For runtime text formatting, consider using:
/// - font(), foregroundStyle() for basic text styling
/// - Custom HTML/CSS styling in your web content
///
/// This modifier is intentionally disabled and will throw a parse error.
@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
public enum AttributedTextFormattingDefinitionModifier<Library: ElementLibrary>: @unchecked Sendable {
    case unsupported
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
extension AttributedTextFormattingDefinitionModifier: RuntimeViewModifier {
    public static var baseName: String { "attributedTextFormattingDefinition" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // The attributedTextFormattingDefinition modifier requires a type conforming to
        // AttributedTextFormattingDefinition, which must be a concrete implementation
        // that defines attribute scopes and value constraints.
        //
        // This cannot be parsed from syntax at runtime since it requires
        // compile-time defined protocol conformances and type definitions.
        throw ModifierParseError.noMatchingVariant(
            modifier: "AttributedTextFormattingDefinitionModifier",
            errors: [ModifierParseError.protocolTypeNotSupported(
                modifier: "attributedTextFormattingDefinition",
                protocolName: "AttributedTextFormattingDefinition",
                suggestion: "Use font(), foregroundStyle(), or other text styling modifiers for runtime text formatting"
            )]
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        // This will never be called since init always throws
        _content
    }
}
