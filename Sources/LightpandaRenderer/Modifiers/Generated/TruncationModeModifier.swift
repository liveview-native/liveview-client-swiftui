import SwiftUI
import SwiftSyntax

/// Modifier for setting text truncation mode.
///
/// Usage:
/// ```html
/// <text modifiers="truncationMode(.head)">
/// <text modifiers="truncationMode(.middle)">
/// <text modifiers="truncationMode(.tail)">
/// ```
public enum TruncationModeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case truncationMode(Text.TruncationMode)
}

extension TruncationModeModifier: RuntimeViewModifier {
    public static var baseName: String { "truncationMode" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let mode = syntax.arguments.first.flatMap({ Text.TruncationMode(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "TruncationModeModifier", argument: "mode")
        }
        self = .truncationMode(mode)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .truncationMode(let mode):
            _content.truncationMode(mode)
        }
    }
}
