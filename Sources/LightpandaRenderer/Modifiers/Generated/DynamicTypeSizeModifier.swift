import SwiftUI
import SwiftSyntax

/// Modifier for setting the dynamic type size.
///
/// Usage:
/// ```html
/// <text modifiers="dynamicTypeSize(.large)">Large Text</text>
/// <text modifiers="dynamicTypeSize(.accessibility1)">Accessibility Text</text>
/// ```
public enum DynamicTypeSizeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case dynamicTypeSize(DynamicTypeSize)
}

extension DynamicTypeSizeModifier: RuntimeViewModifier {
    public static var baseName: String { "dynamicTypeSize" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let size = syntax.arguments.first.flatMap({ DynamicTypeSize(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "DynamicTypeSizeModifier", argument: "size")
        }
        self = .dynamicTypeSize(size)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .dynamicTypeSize(let size):
            _content.dynamicTypeSize(size)
        }
    }
}
