import SwiftUI
import SwiftSyntax

/// Modifier for making views focusable.
public enum FocusableModifier<Library: ElementLibrary>: @unchecked Sendable {
    case focusable(Bool)
}

extension FocusableModifier: RuntimeViewModifier {
    public static var baseName: String { "focusable" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let isFocusable = syntax.arguments.first
            .flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .focusable(isFocusable)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .focusable(let isFocusable):
            if #available(iOS 17.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                _content.focusable(isFocusable)
            } else {
                _content
            }
        }
    }
}
