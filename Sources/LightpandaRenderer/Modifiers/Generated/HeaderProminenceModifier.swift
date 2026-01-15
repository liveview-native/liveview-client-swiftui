import SwiftUI
import SwiftSyntax

/// Modifier for setting header prominence.
///
/// Usage:
/// ```html
/// <section modifiers="headerProminence(.increased)">
/// <section modifiers="headerProminence(.standard)">
/// ```
public enum HeaderProminenceModifier<Library: ElementLibrary>: @unchecked Sendable {
    case headerProminence(Prominence)
}

extension HeaderProminenceModifier: RuntimeViewModifier {
    public static var baseName: String { "headerProminence" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let prominence = syntax.arguments.first.flatMap({ Prominence(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "HeaderProminenceModifier", argument: "prominence")
        }
        self = .headerProminence(prominence)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .headerProminence(let prominence):
            _content.headerProminence(prominence)
        }
    }
}
