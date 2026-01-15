import SwiftUI
import SwiftSyntax

/// Modifier for disabling find/replace functionality.
///
/// Usage:
/// ```html
/// <texteditor modifiers="findDisabled()">...</texteditor>
/// <texteditor modifiers="findDisabled(true)">...</texteditor>
/// ```
#if os(iOS) || os(macOS)
@available(iOS 16.0, macOS 26.0, *)
public enum FindDisabledModifier<Library: ElementLibrary>: @unchecked Sendable {
    case findDisabled(Bool)
}

@available(iOS 16.0, macOS 26.0, *)
extension FindDisabledModifier: RuntimeViewModifier {
    public static var baseName: String { "findDisabled" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let disabled = syntax.arguments.first.flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .findDisabled(disabled)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .findDisabled(let disabled):
            _content.findDisabled(disabled)
        }
    }
}
#endif
