import SwiftUI
import SwiftSyntax

/// Modifier for setting symbol variant.
///
/// Usage:
/// ```html
/// <image systemname="star" modifiers="symbolVariant(.fill)">
/// <image systemname="star" modifiers="symbolVariant(.circle)">
/// ```
public enum SymbolVariantModifier<Library: ElementLibrary>: @unchecked Sendable {
    case symbolVariant(SymbolVariants)
}

extension SymbolVariantModifier: RuntimeViewModifier {
    public static var baseName: String { "symbolVariant" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let variant = syntax.arguments.first.flatMap({ SymbolVariants(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "SymbolVariantModifier", argument: "variant")
        }
        self = .symbolVariant(variant)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .symbolVariant(let variant):
            _content.symbolVariant(variant)
        }
    }
}
