import SwiftUI
import SwiftSyntax

/// Modifier for setting badge prominence.
///
/// Usage:
/// ```html
/// <tabview modifiers="badgeProminence(.increased)">
/// <tabview modifiers="badgeProminence(.decreased)">
/// ```
public enum BadgeProminenceModifier<Library: ElementLibrary>: @unchecked Sendable {
    case badgeProminence(BadgeProminence)
}

extension BadgeProminenceModifier: RuntimeViewModifier {
    public static var baseName: String { "badgeProminence" }

    public init(syntax: FunctionCallExprSyntax) throws {
        guard let prominence = syntax.arguments.first.flatMap({ BadgeProminence(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "BadgeProminenceModifier", argument: "prominence")
        }
        self = .badgeProminence(prominence)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .badgeProminence(let prominence):
            _content.badgeProminence(prominence)
        }
    }
}
