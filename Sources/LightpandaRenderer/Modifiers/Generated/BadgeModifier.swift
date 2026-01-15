import SwiftUI
import SwiftSyntax

/// Modifier for adding badges to views.
///
/// Usage:
/// ```html
/// <tabitem modifiers="badge(5)">
/// <tabitem modifiers='badge("New")'>
/// ```
public enum BadgeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case badgeCount(Int)
    case badgeString(String?)
}

extension BadgeModifier: RuntimeViewModifier {
    public static var baseName: String { "badge" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try parsing as Int first
        if let count = syntax.arguments.first.flatMap({ Int(syntax: $0.expression) }) {
            self = .badgeCount(count)
            return
        }
        // Fall back to String
        let text = syntax.arguments.first.flatMap({ String(syntax: $0.expression) })
        self = .badgeString(text)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .badgeCount(let count):
            _content.badge(count)
        case .badgeString(let text):
            _content.badge(text)
        }
    }
}
