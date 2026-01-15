import SwiftUI
import SwiftSyntax

/// Modifier for hiding the status bar (iOS only).
///
/// Usage:
/// ```html
/// <vstack modifiers="statusBarHidden()">
/// <vstack modifiers="statusBarHidden(true)">
/// <vstack modifiers="statusBarHidden(false)">
/// ```
#if os(iOS)
public enum StatusBarHiddenModifier<Library: ElementLibrary>: @unchecked Sendable {
    case statusBarHidden(Bool)
}

extension StatusBarHiddenModifier: RuntimeViewModifier {
    public static var baseName: String { "statusBarHidden" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let hidden = syntax.arguments.first.flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .statusBarHidden(hidden)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .statusBarHidden(let hidden):
            _content.statusBarHidden(hidden)
        }
    }
}
#endif
