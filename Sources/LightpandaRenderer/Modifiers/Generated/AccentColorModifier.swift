import SwiftUI
import SwiftSyntax

/// Modifier for setting the accent color (deprecated, prefer tint).
///
/// Usage:
/// ```html
/// <button modifiers="accentColor(.red)">
/// <button modifiers="accentColor(.blue)">
/// ```
///
/// Note: This modifier is deprecated. Prefer using `tint()` instead.
public enum AccentColorModifier<Library: ElementLibrary>: @unchecked Sendable {
    case accentColor(Color?)
}

extension AccentColorModifier: RuntimeViewModifier {
    public static var baseName: String { "accentColor" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let color = syntax.arguments.first.flatMap({ Color(syntax: $0.expression) })
        self = .accentColor(color)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .accentColor(let color):
            _content.accentColor(color)
        }
    }
}
